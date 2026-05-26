import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exercices")),  
      drawer: AppDrawer(),
      body: Center(
        child: Text("Exercises"),
      ),
    );
  }
}