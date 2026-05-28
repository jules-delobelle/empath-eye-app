import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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