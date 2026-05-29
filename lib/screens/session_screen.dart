import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../models/detection.dart';
import '../models/session.dart';
import '../services/api_services.dart';

class SessionScreen extends StatefulWidget {

  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen>{

  String? token;
  List<Detection> _detections = [];
  

  @override
  void initState(){
    super.initState();
    loadSession();
  }

  Future<void> loadSession() async{
    token = await ApiServices.getToken();
    final session = ModalRoute.of(context)!.settings.arguments as Session;
    if(token != null){
      final List<Detection>? detections = await ApiServices.getDetections(token!, session.idSession);
      if(detections != null && mounted){
        setState(() {_detections = detections;});
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur dans le chargement de la session"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Session")),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: _detections.length,
        itemBuilder: (context, index) {
          Detection detection = _detections[index];
          return ListTile(
            title: Text("${detection.emotion} | ${detection.heure}"),
            onTap:() => Navigator.pushNamed(context, '/interaction', arguments: detection),
          );
        }
      ),
    );
  }

}