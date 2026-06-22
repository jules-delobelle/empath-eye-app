import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/colors.dart';
import '../utils/get_emotion.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  void _choisirEmotion(BuildContext context) {
    const emotions = ["joie", "tristesse", "colere", "surprise"];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Choisis une émotion",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: appColors['violet_logo'],
                  ),
                ),
                const SizedBox(height: 20),
                ...emotions.map((emotion) {
                  final couleur = emotionColors[emotion] ?? Colors.grey;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: couleur,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // ferme la bottom sheet
                          Navigator.pushNamed(
                            context,
                            "/quiz",
                            arguments: {
                              "type": "quiz_emotion",
                              "emotion": emotion,
                            },
                          );
                        },
                        child: Text(
                          getEmotion(emotion),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

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
                  onPressed: () => Navigator.pushNamed(
                    context,
                    "/quiz",
                    arguments: {"type": "grand_quiz"},
                  ),
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
                  onPressed: () => _choisirEmotion(context),
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