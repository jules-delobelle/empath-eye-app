import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_app_bar.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titre: "Exercices"),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Text("Choisis ton mode d'entrainement !"),
          ElevatedButton(
            onPressed:() => Navigator.pushNamed(context, "/quiz", arguments: "grand_quiz"),
            child: Text("Grand Quiz")
          ),
          ElevatedButton(
            onPressed:() => Navigator.pushNamed(context, "/quiz", arguments: "quiz_emotion"),
            child: Text("Quiz émotion")
          )
        ],
      ),
    );
  }
}