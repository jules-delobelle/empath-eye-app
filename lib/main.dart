import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';

import 'screens/login_screen.dart'; 
import 'screens/exercises_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/interaction_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/quiz_result_screen.dart';
import 'screens/session_screen.dart';
import 'screens/about_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context)
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: { 
        '/about': (context) => const AboutScreen(),
        '/exercises': (context) => const ExercisesScreen(),
        '/history': (context) => const HistoryScreen(),
        '/home': (context) => const HomeScreen(),
        '/interaction': (context) => const InteractionScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/quiz_result' : (context) => const QuizResultScreen(),
        '/session' :(context) => const SessionScreen(),
        '/login':(context) => const LoginScreen()
      }
    );
  }
}


