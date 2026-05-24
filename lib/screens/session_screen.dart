import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Session")),
      drawer: AppDrawer(),
      body: Center(
        child: Text("Session"),
      ),
    );
  }

}