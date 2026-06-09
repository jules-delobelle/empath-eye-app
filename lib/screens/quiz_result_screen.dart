import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_app_bar.dart';
import '../models/quiz_result.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    QuizResultat resultat = ModalRoute.of(context)!.settings.arguments as QuizResultat;
    int scoreTotal = resultat.scoreTotal;
    int nombreQuestions = resultat.nombreQuestions;
    return Scaffold(
      appBar: CustomAppBar(titre: "Quiz"),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Text((scoreTotal / nombreQuestions * 100).round().toString()),
          if(resultat.type == "grand_quiz") ... [
            ...resultat.bonnesReponsesParEmotion.entries.map((entry) =>
              Row(
                children: [
                  Text(entry.key),
                  Text("${(entry.value / resultat.questionsParEmotion[entry.key]! * 100).round()}%")
                ]
              )
            )
          ]
        ]
      ),
    );
  }

}