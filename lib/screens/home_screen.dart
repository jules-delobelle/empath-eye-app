import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../widgets/app_drawer.dart';
import '../widgets/connexion_card.dart';
import '../widgets/connexion_dialog.dart';
import '../widgets/emotion_graph.dart';
import '../models/enfant.dart';
import '../providers/app_provider.dart';
import '../services/ble_service.dart';

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
              onReessayer: () => _lancerScan(),
          );
        }
      ) 
    );
  }

  void _lancerScan() async {
    BLEService.scanDevices().listen((appareils) {
      if(appareils.isNotEmpty){
        setState(() { _etat = EtatConnexion.connecte; });
        _setDialogState?.call(() {});
        BLEService.stopScan();
      }
    });

    await Future.delayed(Duration(seconds: 5));
    if(_etat != EtatConnexion.connecte){
      setState(() { _etat = EtatConnexion.erreur; });
      _setDialogState?.call(() {});
    }
  }

  void _telecharger() async{
    List<ScanResult> appareils = await BLEService.scanDevices().first;
    ScanResult? lunettes;
    for (var appareil in appareils) {
      if (appareil.device.platformName == "EmpathEye") {
          lunettes = appareil;
          break;
        }
    }
    if (lunettes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lunettes introuvables"))
      );
      return;
    }

    await BLEService.connect(lunettes.device);
    await BLEService.sendCommand(lunettes.device, "REQUEST_FILES");

    String? nomFichierEnCours;
    List<int> buffer = [];
    int tailleAttendue = 0;

    await for (var paquet in BLEService.listenTransfer(lunettes.device)){
      try{
        dynamic json = jsonDecode(utf8.decode(paquet));
        if(json["name"] == "__END__"){
          break;
        }

        nomFichierEnCours = json["name"];
        tailleAttendue = json["size"];
        buffer = [];
      }catch(e){
        buffer.addAll(paquet);

        if(buffer.length >= tailleAttendue){
          String contenu = utf8.decode(buffer);
        }
      }
    }
    await BLEService.sendCommand(lunettes.device, "TRANSFER_OK");

    await BLEService.disconnect(lunettes.device);
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
              _ouvrirDialog();
              _lancerScan();
            }
          ),
          EmotionGraph()
        ]
      ),
    );
  }
}