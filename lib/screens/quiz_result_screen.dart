import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz")),
      drawer: AppDrawer(),
      body: Center(
        child: Text("QuizResult"),
      ),
    );
  }

}