import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("À propos")),
      drawer: AppDrawer(),
      body: Center(
        child: Text("About"),
      ),
    );
  }

}