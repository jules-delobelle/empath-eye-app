import '../models/quiz/quiz_question.dart';

class QuizService {

  static const List<String> emotions = ["joie", "tristesse", "colere", "surprise"];
  static const int imagesParEmotion = 15;
  static const int questionsParEmotion = 3;
  static const int questionsParEmotionFiltree = 12; // nb de questions si une seule émotion choisie

  static List<QuizQuestion> genererQuestions({String? emotionFiltree}) {
    List<QuizQuestion> toutesLesQuestions = [];

    if (emotionFiltree != null) {
      // --- Quiz émotion ciblé sur une seule émotion ---
      List<QuizQuestion> questionsEmotion = [];

      for (int i = 1; i <= imagesParEmotion; i++) {
        questionsEmotion.add(QuizQuestion(
          path: "assets/images/emotions/$emotionFiltree/$emotionFiltree$i.jpg",
          emotion: emotionFiltree,
        ));
      }

      questionsEmotion.shuffle();
      toutesLesQuestions.addAll(
        questionsEmotion.take(questionsParEmotionFiltree),
      );
    } else {
      // --- Comportement existant : toutes les émotions mélangées ---
      for (var emotion in emotions) {
        List<QuizQuestion> questionsEmotion = [];

        for (int i = 1; i <= imagesParEmotion; i++) {
          questionsEmotion.add(QuizQuestion(
            path: "assets/images/emotions/$emotion/$emotion$i.jpg",
            emotion: emotion,
          ));
        }

        questionsEmotion.shuffle();
        toutesLesQuestions.addAll(questionsEmotion.take(questionsParEmotion));
      }
    }

    toutesLesQuestions.shuffle();
    return toutesLesQuestions;
  }

}