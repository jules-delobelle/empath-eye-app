import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class InteractionScreen extends StatelessWidget {
  const InteractionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Interaction")),
      drawer: AppDrawer(),
      body: Center(
        child: Text("Interaction"),
      ),
    );
  }

}