import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/app_drawer.dart';
import '../models/quiz_question.dart';
import '../models/quiz_result.dart';
import '../services/quiz_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>{

  List<QuizQuestion>? _questions;
  int _indexActuel = 0;
  int _score = 0;
  bool _reponsedonne = false;
  bool _bonneReponse = false;
  String? _type;
  List<String> _emotionsMelangees = [];
  String? _emotionAffichee;
  Map<String, int> _bonnesReponsesParEmotion = {"joie": 0, "tristesse": 0, "colere": 0, "surprise": 0};
  Map<String, int> _questionsParEmotion = {"joie": 0, "tristesse": 0, "colere": 0, "surprise": 0};

  void _nouvelleQuestion(){
    setState(() {
      _emotionsMelangees = [...QuizService.emotions]..shuffle();
      _reponsedonne = false;
      _bonneReponse = false;
    },); 
    if(_type == "quiz_emotion"){
      if(Random().nextInt(2) == 0){
        setState(() => _emotionAffichee = _questions![_indexActuel].emotion);
      }else{
        List<String> autresEmotions = QuizService.emotions.where((e) => e != _questions![_indexActuel].emotion).toList();
        setState(() => _emotionAffichee = autresEmotions[Random().nextInt(autresEmotions.length)]);
      } 
    }
  }

  void _repondre(String emotion){
    String emotionQuestion = _questions![_indexActuel].emotion;
    setState(() {
      _questionsParEmotion[emotionQuestion] = _questionsParEmotion[emotionQuestion]! + 1;
      _reponsedonne = true;
      if(emotion == _questions![_indexActuel].emotion){
        _bonneReponse = true;
        _bonnesReponsesParEmotion[emotionQuestion] = _bonnesReponsesParEmotion[emotionQuestion]! + 1;
        _score++;
      }else{
        _bonneReponse = false;
      }
    });
  }

  void _repondreVraiFaux(bool reponse){
    bool bonneEmotion = (_emotionAffichee == _questions![_indexActuel].emotion);
    String emotionQuestion = _questions![_indexActuel].emotion;
    setState(() {
      _questionsParEmotion[emotionQuestion] = _questionsParEmotion[emotionQuestion]! + 1;
      _reponsedonne = true;
      if (reponse == bonneEmotion){
        _bonneReponse = true;
        _bonnesReponsesParEmotion[emotionQuestion] = _bonnesReponsesParEmotion[emotionQuestion]! + 1;
        _score++;
      }else{
        _bonneReponse = false;
      }
    });
  }

  void _suivant(){
    if(_indexActuel < _questions!.length - 1){
      setState(() { _indexActuel++; });
      _nouvelleQuestion();
    }else{
      Navigator.pushNamed(
        context, 
        "/quiz_result", 
        arguments: QuizResultat(
          scoreTotal: _score,
          nombreQuestions: _questions!.length,
          bonnesReponsesParEmotion: _bonnesReponsesParEmotion,
          questionsParEmotion: _questionsParEmotion,
          type: _type!
        )
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();  
    if (_questions == null){
      _type = ModalRoute.of(context)!.settings.arguments as String;
      _questions = QuizService.genererQuestions();
      _nouvelleQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz")),
      drawer: AppDrawer(), 
      body: Column(
        children: [
          if(_type == "grand_quiz") ...[
            Image.asset(_questions![_indexActuel].path),
            Text("Quelle émotion est décrite sur l'image ?"),
            ..._emotionsMelangees.map((emotion) => ElevatedButton(
              onPressed: _reponsedonne ? null : () => _repondre(emotion),
              child: Text(emotion)  
            )),
          ]else ...[
            Text(_emotionAffichee ?? ""),
            Image.asset(_questions![_indexActuel].path),
            Text("Est ce que l'image correspond à cette emotion ?"),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _reponsedonne? null : () => _repondreVraiFaux(true),
                  child: Text("VRAI"),
                ),
                ElevatedButton(
                  onPressed: _reponsedonne? null: () => _repondreVraiFaux(false),
                  child: Text("FAUX")
                )
              ]
            )
          ],
          if(_reponsedonne) IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () => _suivant()
          )
        ]
      )
    );
  }
}