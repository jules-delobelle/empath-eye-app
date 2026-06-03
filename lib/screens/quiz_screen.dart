import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../models/quiz_question.dart';
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

  void _nouvelleQuestion(){
    setState(() {
      _emotionsMelangees = [...QuizService.emotions]..shuffle();
      _reponsedonne = false;
      _bonneReponse = false;
    },); 
  }

  void _repondre(String emotion){
    setState(() {
      _reponsedonne = true;
      if(emotion == _questions![_indexActuel].emotion){
        _bonneReponse = true;
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
      Navigator.pushNamed(context, "/quiz_result", arguments: _score);
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
          Image.asset(_questions![_indexActuel].path),
          Text("Quelle émotion est décrite sur l'image ?"),
          ..._emotionsMelangees.map((emotion) => ElevatedButton(
            onPressed: _reponsedonne ? null : () => _repondre(emotion),
            child: Text(emotion)
          )),
          if(_reponsedonne) IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () => _suivant()
          )
        ]
      )
    );
  }
}