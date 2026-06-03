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

enum EtatConnexion {recherche, connecte, erreur}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
} 

class _HomeScreenState extends State<HomeScreen>{
  EtatConnexion _etat = EtatConnexion.recherche;
  StateSetter? _setDialogState;

  void _ouvrirDialog(){
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder : (context, setDialogState) {
            _setDialogState = setDialogState;
            return ConnexionDialog(
              etat: _etat,
              onAnnuler: () => Navigator.pop(context),
              onReessayer: () => _telecharger(),
          );
        }
      ) 
    );
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Bienvenue ${enfant?.prenom ?? '...'} sur Empath'Eye"),
          ConnexionCard(
            onTelecharger: () {
              setState(() {_etat = EtatConnexion.recherche;});
              _telecharger();
            }
          ),
          EmotionGraph()
        ]
      ),
    );
  }
}