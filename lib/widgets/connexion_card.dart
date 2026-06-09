import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConnexionCard extends StatelessWidget {
  final VoidCallback onTelecharger;
  final DateTime? dernierTelechargement;
  
  const ConnexionCard({super.key, required this.onTelecharger, required this.dernierTelechargement});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Color(0xFF9CC78D),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        children: [
          Icon(Icons.bluetooth, size: 50),
          SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 14),  
              children: [
                TextSpan(text: "Dernier téléchargement : "),
                TextSpan(
                    text: 
                      dernierTelechargement != null 
                      ? "Dernier téléchargement : ${DateFormat('d MMMM yyyy, HH\'h\'mm', 'fr').format(dernierTelechargement!)}"
                      : "Aucun téléchargement",
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),
              ]
            )
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTelecharger,
            child: Text("Téléverser", style: TextStyle(color: Color(0xFF276811), fontSize: 20))
          )
        ]
      )
    );  
  }

}