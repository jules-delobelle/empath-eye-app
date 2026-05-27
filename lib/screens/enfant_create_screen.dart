import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../services/api_services.dart';

class CreateEnfantScreen extends StatefulWidget {
  const CreateEnfantScreen({super.key});

  @override
  State<CreateEnfantScreen> createState() => _CreateEnfantScreenState();

}

class _CreateEnfantScreenState extends State<CreateEnfantScreen> {
  final _prenomController = TextEditingController();
  DateTime? naissance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter un enfant")),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          children: [

            TextField(
              controller: _prenomController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Prénom"
              )
            ),

            ElevatedButton(
              onPressed: () async {
                pickDate();
              },
              child: Text("Sélectionner une date")
            ),

            Text(naissance != null ? naissance.toString() : "Aucune date sélectionnée"),

            ElevatedButton(
              onPressed: () async {
                String? token;

                token = await ApiServices.getToken();

                if(token != null){
                  bool? create = await ApiServices.createEnfant(token, _prenomController.text, naissance);
                  
                  if(create == true){
                    Navigator.pop(context);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erreur lors de la création"))
                    );
                  }
                }
              },
              child: Text("Créer")
            )
          ]
        ),
      ),
    );
  }

  void pickDate() async{
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now()
    );
    if (date != null){
      setState(() {naissance = date; });
    }
  }
}