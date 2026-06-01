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
  List<Detection> _importantDetections = [];
  Session? _session;
  

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
        final List<Detection> importantDetections = detections.where((d) => d.important == true).toList();
        detections.sort((a, b) => b.heure!.compareTo(a.heure!));
        importantDetections.sort((a, b) => b.heure!.compareTo(a.heure!));
        setState(() {_detections = detections; _importantDetections = importantDetections; _session = session;});
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
      body: SingleChildScrollView(
        child: Column( 
          children: [
            Text("Session du ${_session?.date ?? "Chargement en cours..."}"),
            Text("Interactions importantes"),
            ..._importantDetections.map((detection) => ListTile(
              title: Text(detection.emotion),
              onTap: () => Navigator.pushNamed(context, "/interaction", arguments: detection),
            )),
            Text("Interactions de la session"),
            ..._detections.map((detection) => ListTile(
              title: Text(detection.emotion),
              onTap:() => Navigator.pushNamed(context, "/interaction", arguments: detection)
            ))
          ]
        )
      ),
    );
  }
}