import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/app_drawer.dart';
import '../widgets/custom_app_bar.dart';
import '../models/quiz/quiz_question.dart';
import '../models/quiz/quiz_result.dart';
import '../services/quiz_service.dart';
import '../utils/colors.dart';
import '../utils/get_emotion.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuizQuestion>? _questions;
  int _indexActuel = 0;
  int _score = 0;
  bool _reponsedonne = false;
  bool _bonneReponse = false;
  String? _type;
  List<String> _emotionsMelangees = [];
  String? _emotionAffichee;
  String? _reponseSelectionnee;         // pour grand_quiz
  bool? _reponseVraiFaux;               // pour quiz_emotion
  Map<String, int> _bonnesReponsesParEmotion = {"joie": 0, "tristesse": 0, "colere": 0, "surprise": 0};
  Map<String, int> _questionsParEmotion = {"joie": 0, "tristesse": 0, "colere": 0, "surprise": 0};

  void _nouvelleQuestion() {
    setState(() {
      _emotionsMelangees = [...QuizService.emotions]..shuffle();
      _reponsedonne = false;
      _bonneReponse = false;
      _reponseSelectionnee = null;
      _reponseVraiFaux = null;
    });
    if (_type == "quiz_emotion") {
      if (Random().nextInt(2) == 0) {
        setState(() => _emotionAffichee = _questions![_indexActuel].emotion);
      } else {
        List<String> autresEmotions = QuizService.emotions
            .where((e) => e != _questions![_indexActuel].emotion)
            .toList();
        setState(() => _emotionAffichee =
            autresEmotions[Random().nextInt(autresEmotions.length)]);
      }
    }
  }

  void _selectionnerReponse(String emotion) {
    // Permet de changer la réponse avant de valider
    setState(() {
      _reponseSelectionnee = emotion;
    });
  }

  void _validerReponse() {
    if (_reponseSelectionnee == null) return;
    String emotionQuestion = _questions![_indexActuel].emotion;
    setState(() {
      _questionsParEmotion[emotionQuestion] =
          _questionsParEmotion[emotionQuestion]! + 1;
      _reponsedonne = true;
      if (_reponseSelectionnee == emotionQuestion) {
        _bonneReponse = true;
        _bonnesReponsesParEmotion[emotionQuestion] =
            _bonnesReponsesParEmotion[emotionQuestion]! + 1;
        _score++;
      } else {
        _bonneReponse = false;
      }
    });
  }

  void _selectionnerVraiFaux(bool reponse) {
    // Permet de changer la réponse avant de valider
    setState(() {
      _reponseVraiFaux = reponse;
    });
  }

  void _validerVraiFaux() {
    if (_reponseVraiFaux == null) return;
    bool bonneEmotion = (_emotionAffichee == _questions![_indexActuel].emotion);
    String emotionQuestion = _questions![_indexActuel].emotion;
    setState(() {
      _questionsParEmotion[emotionQuestion] =
          _questionsParEmotion[emotionQuestion]! + 1;
      _reponsedonne = true;
      if (_reponseVraiFaux == bonneEmotion) {
        _bonneReponse = true;
        _bonnesReponsesParEmotion[emotionQuestion] =
            _bonnesReponsesParEmotion[emotionQuestion]! + 1;
        _score++;
      } else {
        _bonneReponse = false;
      }
    });
  }

  void _suivant() {
    if (_indexActuel < _questions!.length - 1) {
      setState(() { _indexActuel++; });
      _nouvelleQuestion();
    } else {
      Navigator.pushNamed(
        context,
        "/quiz_result",
        arguments: QuizResultat(
          scoreTotal: _score,
          nombreQuestions: _questions!.length,
          bonnesReponsesParEmotion: _bonnesReponsesParEmotion,
          questionsParEmotion: _questionsParEmotion,
          type: _type!,
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_questions == null) {
      _type = ModalRoute.of(context)!.settings.arguments as String;
      _questions = QuizService.genererQuestions();
      _nouvelleQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titre: "Quiz"),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_type == "grand_quiz") ...[
              // --- Grand Quiz ---
              Image.asset(_questions![_indexActuel].path,
              height: 300,
              fit: BoxFit.contain,),
              const SizedBox(height: 16),
              Text(
                "Quelle émotion est décrite sur l'image ?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: appColors['violet_logo'],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Grille 2x2
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.2,
                children: _emotionsMelangees.map((emotion) {
                  final isSelected = _reponseSelectionnee == emotion;
                  final couleur = emotionColors[emotion] ?? Colors.grey;
                  return ElevatedButton(
                    onPressed: _reponsedonne
                        ? null
                        : () => _selectionnerReponse(emotion),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: couleur,
                      foregroundColor: Colors.white,
                      side: isSelected
                          ? BorderSide(color: appColors['vert_clair'] ?? Colors.black, width: 3)
                          : BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: isSelected ? 6 : 2,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(getEmotion(emotion)),
                  );
                }).toList(),
              ),
              //const SizedBox(height: 8),
              // Bouton Valider (grand_quiz)
              if (!_reponsedonne)
                ElevatedButton(
                  onPressed: _reponseSelectionnee != null ? _validerReponse : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text(
                    "Valider",
                    style : TextStyle(
                        color : appColors['violet_logo'] ?? Colors.black,
                    )
                  ),
                ),
              // Feedback + suivant
              if (_reponsedonne) ...[
                const SizedBox(height: 12),
                Icon(
                  _bonneReponse ? Icons.check_circle : Icons.cancel,
                  color: _bonneReponse ? Colors.green : Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: Icon(Icons.arrow_forward, size: 36, color: appColors['vert_fonce']),
                  onPressed: _suivant,
                ),
              ],
            ] else ...[
              // --- Quiz Émotion (Vrai/Faux) ---
              const SizedBox(height: 8),
              // Bandeau émotion coloré
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: emotionColors[_emotionAffichee] ?? Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  getEmotion(_emotionAffichee),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Image.asset(_questions![_indexActuel].path,
              height: 320,
              fit: BoxFit.contain,),
              const SizedBox(height: 16),
              const Text(
                "Est-ce que l'image correspond à cette émotion ?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Boutons Vrai / Faux côte à côte, centrés, colorés
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _boutonVraiFaux("VRAI", true, Colors.blue),
                  const SizedBox(width: 20),
                  _boutonVraiFaux("FAUX", false, Colors.red),
                ],
              ),
              const SizedBox(height: 16),
              // Bouton Valider (quiz_emotion)
              if (!_reponsedonne)
                ElevatedButton(
                  onPressed: _reponseVraiFaux != null ? _validerVraiFaux : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text(
                    "Valider",
                    style : TextStyle(
                        color : appColors['violet_logo'] ?? Colors.black,
                    )
                  ),
                ),
              // Feedback + suivant
              if (_reponsedonne) ...[
                const SizedBox(height: 12),
                Icon(
                  _bonneReponse ? Icons.check_circle : Icons.cancel,
                  color: _bonneReponse ? Colors.green : Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: Icon(Icons.arrow_forward, size: 36, color: appColors['vert_fonce']),
                  onPressed: _suivant,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _boutonVraiFaux(String label, bool valeur, Color couleur) {
    final isSelected = _reponseVraiFaux == valeur;
    return SizedBox(
      width: 130,
      height: 60,
      child: ElevatedButton(
        onPressed: _reponsedonne ? null : () => _selectionnerVraiFaux(valeur),
        style: ElevatedButton.styleFrom(
          backgroundColor: couleur,
          foregroundColor: Colors.white,
          side: isSelected
              ? BorderSide(color: appColors['vert_clair'] ?? Colors.black, width: 3)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isSelected ? 6 : 2,
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}