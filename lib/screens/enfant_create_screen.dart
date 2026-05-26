import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class CreateEnfantScreen extends StatelessWidget {
  const CreateEnfantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Création d'enfants")),
      drawer: AppDrawer(),
      body: Center(
        child: Text("Creating child"),
      ),
    );
  }

}