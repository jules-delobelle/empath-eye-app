import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../widgets/app_drawer.dart';
import '../widgets/connexion_card.dart';
import '../widgets/connexion_dialog.dart';
import '../widgets/emotion_graph.dart';
import '../models/enfant.dart';
import '../models/session.dart';
import '../providers/app_provider.dart';
import '../services/ble_service.dart';
import '../services/api_services.dart';
import '../utils/colors.dart';

enum EtatConnexion {recherche, connecte, erreur}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
} 

class _HomeScreenState extends State<HomeScreen>{
  EtatConnexion _etat = EtatConnexion.recherche;
  Map<String, int> _stats = {"joie": 0, "tristesse": 0, "colere": 0, "surprise": 0};
  StateSetter? _setDialogState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadStats();
  }

  void _ouvrirDialog(){
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder : (context, setDialogState) {
            _setDialogState = setDialogState;
            return ConnexionDialog(
              etat: _etat,
              onAnnuler: () => Navigator.pop(context),
              onReessayer: () {
                Navigator.pop(context);
                _telecharger();
              }
          );
        }
      ) 
    );
  }

  Future<void> _loadStats() async{
    String? token = await ApiServices.getToken();
    Enfant? enfant = Provider.of<AppProvider>(context, listen: false).getEnfantSelectionne();
    if(token != null && enfant != null){
      Map<String, int>? stats = await ApiServices.getStats(token, enfant.idEnfant);
      if(stats != null){
        setState(() => _stats = stats);
      }
    }
  }

  void _telecharger() async{
    String? token = await ApiServices.getToken();
    Enfant? enfant = Provider.of<AppProvider>(context, listen: false).getEnfantSelectionne();

    if(token == null || enfant == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement"))
      );
      return;
    }

    _ouvrirDialog();

    List<ScanResult> appareils = await BLEService.scanDevices().first;
    ScanResult? lunettes;
    for (var appareil in appareils) {
      if (appareil.device.platformName == "EmpathEye") {
          lunettes = appareil;
          break;
        }
    }
    if (lunettes == null) {
      setState(() {_etat = EtatConnexion.erreur;});
      _setDialogState?.call(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lunettes introuvables"))
      );
      return;
    }

    setState(() {_etat = EtatConnexion.connecte;});
    _setDialogState?.call(() {});

    await BLEService.connect(lunettes.device);
    await BLEService.sendCommand(lunettes.device, "REQUEST_FILES");

    List<int> buffer = [];
    int tailleAttendue = 0;
    List<Session>? sessions = await ApiServices.getSessions(token, enfant.idEnfant);
    Session? sessionDuJour;
    
    if (sessions != null){
      for (var session in sessions){
        if(session.date != null){ 
          if (
              session.date!.year == DateTime.now().year &&
              session.date!.month == DateTime.now().month &&
              session.date!.day == DateTime.now().day
              ){
            sessionDuJour = session;
            break;
              }
        }
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de session"))
      );
      return;
    }

    if (sessionDuJour == null){
      sessionDuJour = await ApiServices.createSession(token, DateTime.now(), enfant.idEnfant);
    }

    if(sessionDuJour == null) return;

    await for (var paquet in BLEService.listenTransfer(lunettes.device)){
      try{
        dynamic json = jsonDecode(utf8.decode(paquet));
        if(json["name"] == "__END__"){
          break;
        }

        tailleAttendue = json["size"];
        buffer = [];
      }catch(e){
        buffer.addAll(paquet);

        if(buffer.length >= tailleAttendue){
          Map detectionJson = jsonDecode(utf8.decode(buffer));
          await ApiServices.createDetection(
            token, 
            sessionDuJour.idSession, 
            detectionJson["emotion"], 
            DateTime.parse(detectionJson["heure"]), 
            detectionJson["important"]);
        }
      }
    }
    await BLEService.sendCommand(lunettes.device, "TRANSFER_OK");

    await BLEService.disconnect(lunettes.device);

    await ApiServices.updateDernierTelechargement(token, enfant.idEnfant);

    final enfants = await ApiServices.getEnfants(token);
    if (enfants != null && mounted) {
        Provider.of<AppProvider>(context, listen: false).setEnfants(enfants);
        
        final enfantMisAJour = enfants.firstWhere((e) => e.idEnfant == enfant.idEnfant);
        Provider.of<AppProvider>(context, listen: false).setEnfantSelectionne(enfantMisAJour);
    }


    await _loadStats();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Enfant? enfant = Provider.of<AppProvider>(context).getEnfantSelectionne();
    return Scaffold(
      appBar: AppBar(
        title: Text("Accueil")
        ),
      drawer: AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 18),
              children: [
                TextSpan(text: "Bienvenue "),
                TextSpan(
                    text: enfant?.prenom ?? '...',
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),
                TextSpan(text: " sur Empath'Eye"),
              ]
            )
          ),
          SizedBox(height: 16),
          ConnexionCard(
            onTelecharger: () {
              setState(() {_etat = EtatConnexion.recherche;});
              _telecharger();
            },
            dernierTelechargement: enfant?.dernierTelechargement
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Émotions rencontrées sur les 7 dernières sessions :", style: TextStyle(fontSize: 13))
          ),
          SizedBox(height: 10,),
          EmotionGraph(stats: _stats),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(text: "Prêt à "),
                TextSpan(
                    text: "progresser ",
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),
                TextSpan(text: "aujourd'hui ?"),
              ]
            )
          ),
          SizedBox(height: 8,),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/exercises'),
                      child: Text("Viens t'entraîner !", style: TextStyle(fontSize: 18, color: appColors["vert_fonce"]))
                  )
              )
          )
        ]
      ),
    );
  }
}