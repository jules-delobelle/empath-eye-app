import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/colors.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titre: "Exercices"),
      drawer: AppDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/mascotte/mascotte_pensee.png',
                height: 250,
              ),
              const SizedBox(height: 24),
              Text(
                "Choisis ton mode d'entraînement !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: appColors['violet_logo'],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, "/quiz", arguments: "grand_quiz"),
                  child: Text(
                    "Grand Quiz",
                    style: TextStyle(
                      color: appColors['vert_fonce'],
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, "/quiz", arguments: "quiz_emotion"),
                  child: Text(
                    "Quiz émotion",
                    style: TextStyle(
                      color: appColors['vert_fonce'],
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}