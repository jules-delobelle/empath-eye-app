import '../models/quiz_question.dart';

class QuizService {
  
  static const List<String> emotions = ["joie", "tristesse", "colere", "surprise"];
  static const int imagesParEmotion = 15;
  static const int questionsParEmotion = 3;
  
  static List<QuizQuestion> genererQuestions(){
    List<QuizQuestion> toutesLesQuestions = [];

    for (var emotion in emotions){
      List<QuizQuestion> questionsEmotion = [];

      for (int i = 1; i <= imagesParEmotion; i++){
        questionsEmotion.add(QuizQuestion(path: "assets/images/emotions/$emotion/$emotion$i.jpg", emotion: emotion));
      }

      questionsEmotion.shuffle();
      toutesLesQuestions.addAll(questionsEmotion.take(questionsParEmotion));
    }

    toutesLesQuestions.shuffle();
    return toutesLesQuestions;
  }
  
}