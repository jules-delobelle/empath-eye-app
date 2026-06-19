import 'package:flutter/material.dart';

import '../../screens/home_screen.dart';

class ConnexionDialog extends StatelessWidget{
  final EtatConnexion etat;
  final VoidCallback onAnnuler;
  final VoidCallback onReessayer;
  
  const ConnexionDialog({super.key, required this.etat, required this.onAnnuler, required this.onReessayer});

  @override
  Widget build(BuildContext contexte){
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcone(),
            SizedBox(height: 16,),
            Text(_buildMessage()),
            SizedBox(height: 16,),
            if (etat == EtatConnexion.recherche)
              TextButton(
                onPressed: onAnnuler,
                child: Text("Annuler"),
              ),
            if (etat == EtatConnexion.erreur)
              ElevatedButton(
                onPressed: onReessayer,
                child: Text("Réessayer"),
              ),
          ]
        )
      )
    ); 
  }

  String _buildMessage(){
    switch(etat){
      case EtatConnexion.recherche:
        return "Recherche des lunettes";
      case EtatConnexion.connecte:
        return "Lunettes trouvées, connexion...";
      case EtatConnexion.transfert:
        return "Transfert des données en cours...";
      case EtatConnexion.termine:
        return "Transfert terminé !";
      case EtatConnexion.erreur:
        return "Aucun appareil trouvé";
    }
  }

  Widget _buildIcone(){
    switch(etat){
      case EtatConnexion.recherche :
      case EtatConnexion.connecte: 
      case EtatConnexion.transfert:
        return CircularProgressIndicator();
      case EtatConnexion.termine:
        return Icon(Icons.check_circle, color: Colors.green);
      case EtatConnexion.erreur:
        return Icon(Icons.error, color: Colors.red);
    }
  }
}