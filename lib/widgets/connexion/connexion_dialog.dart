import 'package:flutter/material.dart';

import '../../screens/home_screen.dart';

class ConnexionDialog extends StatelessWidget{
  final EtatConnexion etat;
  final VoidCallback onAnnuler;
  final VoidCallback onReessayer;
  
  const ConnexionDialog({super.key, required this.etat, required this.onAnnuler, required this.onReessayer});

  @override
  Widget build(BuildContext contexte){
    return AlertDialog(
      content: switch(etat) {
        EtatConnexion.recherche => Column(
          children: [
            CircularProgressIndicator(),
            Text("Recherche des lunettes"),
            ElevatedButton(
              onPressed: onAnnuler,
              child: Text("Annuler")
            )
          ]
        ),
        EtatConnexion.connecte => Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            Text("Lunettes connectées !")
          ]
        ),
        EtatConnexion.erreur => Column(
          children: [
            Icon(Icons.error, color: Colors.red ),
            Text("Aucun appareil trouvé"),
            ElevatedButton(
              onPressed: onReessayer,
              child: Text("Réessayer")
            )
          ]
        ),
      }
    ); 
  }
}