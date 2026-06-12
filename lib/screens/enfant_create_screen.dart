import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/app_drawer.dart';
import '../widgets/custom_app_bar.dart';
import '../services/api_services.dart';
import '../utils/colors.dart';

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
      appBar: CustomAppBar(titre: "Ajouter un enfant"),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 24),
            Image.asset(
              "assets/images/mascotte/mascotte_love.png",
              height: 200,
            ),
            SizedBox(height: 32),
            TextField(
              controller: _prenomController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: appColors["vert_fonce"]!)
                ),
                labelText: "Prénom",
                labelStyle: TextStyle(color: appColors["violet_logo"])
              )
            ),
            SizedBox(height: 16),

            GestureDetector(
              onTap: pickDate,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: appColors["vert_clair"],
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      naissance != null
                      ? DateFormat('dd MMMM yyyy', 'fr').format(naissance!)
                      : "Sélectionner une date de naissance",
                      style: TextStyle(color: appColors["violet_logo"], fontWeight: FontWeight.bold)
                    ),
                    Icon(Icons.calendar_today, color: appColors["violet_logo"])
                  ]
                )
              )
            ),

            SizedBox(height: 40),
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
              child: Text("Créer", style: TextStyle(fontSize: 18, color: appColors["vert_fonce"]))
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