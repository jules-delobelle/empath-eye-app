import 'package:flutter/material.dart';

class ConnexionCard extends StatelessWidget {
  final VoidCallback onTelecharger;
  
  const ConnexionCard({super.key, required this.onTelecharger});

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF9CC78D),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        children: [
          Icon(Icons.visibility),
          Text("Dernier téléchargement : 27 mai 2026, 20h03"),
          ElevatedButton(
            onPressed: onTelecharger,
            child: Text("Téléverser")
          )
        ]
      )
    );  
  }

}