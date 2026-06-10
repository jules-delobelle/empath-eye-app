import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'providers/app_provider.dart';
import 'services/api_services.dart';
import 'models/enfant.dart';
import 'utils/colors.dart';

import 'screens/login_screen.dart'; 
import 'screens/exercises_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/interaction_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/quiz_result_screen.dart';
import 'screens/session_screen.dart';
import 'screens/about_screen.dart';
import 'screens/enfant_create_screen.dart';
import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr', null);
  String? token = await ApiServices.getToken();
  int? enfantId = await ApiServices.getEnfantId();
  
  Enfant? enfantSaved;
  
  String initialRoute;
  if(token == null){
    initialRoute = "/login";
  }else{ 
    initialRoute = "/home";
    List<Enfant>? enfants = await ApiServices.getEnfants(token);
    if(enfants != null){
      for (var enfant in enfants){
        if(enfant.idEnfant == enfantId){
          enfantSaved = enfant;
        }
      }
    }
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(enfantInitial: enfantSaved),
      child: MyApp(initialRoute: initialRoute)
    )
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  
  const MyApp({super.key, required this.initialRoute});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      initialRoute: initialRoute,
      routes: { 
        '/about': (context) => const AboutScreen(),
        '/exercises': (context) => const ExercisesScreen(),
        '/history': (context) => const HistoryScreen(),
        '/home': (context) => const HomeScreen(),
        '/interaction': (context) => const InteractionScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/quiz_result' : (context) => const QuizResultScreen(),
        '/session' : (context) => const SessionScreen(),
        '/login': (context) => const LoginScreen(),
        '/create_enfant': (context) => const CreateEnfantScreen(),
        '/register': (context) => const RegisterScreen(),
      },
      theme: ThemeData(
        textTheme : TextTheme(
          bodyMedium: TextStyle(color: appColors["violet_logo"]),
        )
      )
    );
  }
}


