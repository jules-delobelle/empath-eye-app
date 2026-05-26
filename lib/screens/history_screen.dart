import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historique")),
      drawer: AppDrawer(),
      body: Center(
        child: Text("History"),
      ),
    );
  }

}