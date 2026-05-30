import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../models/detection.dart';

class InteractionScreen extends StatefulWidget {
  const InteractionScreen({super.key});

  State<InteractionScreen> createState() => _InteractionScreenState();

}

class _InteractionScreenState extends State<InteractionScreen>{

  Detection? _detection;

  @override
  void initState(){
    super.initState();
    final detection = ModalRoute.of(context)!.settings.arguments as Detection;
    setState(() {_detection = detection;});
  }



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