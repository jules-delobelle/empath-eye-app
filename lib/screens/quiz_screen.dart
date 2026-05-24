import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz")),
      drawer: AppDrawer(),
      body: Center(
        child: Text("Quiz"),
      ),
    );
  }

}