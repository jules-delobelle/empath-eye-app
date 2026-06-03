class QuizResultat{
    int scoreTotal;
    int nombreQuestions;
    Map<String, int> bonnesReponsesParEmotion;
    Map<String, int> questionsParEmotion;
    String type;

    QuizResultat({
      required this.scoreTotal, 
      required this.nombreQuestions, 
      required this.bonnesReponsesParEmotion, 
      required this.questionsParEmotion,
      required this.type
      });
}