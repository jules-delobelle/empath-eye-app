import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/app_drawer.dart';
import '../widgets/tiles/detection_tile.dart';
import '../widgets/custom_app_bar.dart';
import '../models/detection.dart';
import '../models/session.dart';
import '../services/api_services.dart';
import '../utils/colors.dart';

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
      appBar: CustomAppBar(titre: "Session"),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column( 
          children: [
            Text(
              _session != null
              ? "Session du ${DateFormat('d MMMM yyyy', 'fr').format(_session!.date!)}"
              : "Chargement...",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: appColors["violet_logo"])
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children:[
                  Text(
                    "Interactions importantes",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: appColors["violet_clair"])
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Divider()
                    )
                ]
              )
            ),
            ..._importantDetections.map((detection) => DetectionTile(
              detection: detection,
              onTap: () => Navigator.pushNamed(context, "/interaction", arguments: detection),
              showDate: false,
              showSeconds: true
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children:[
                  Text(
                    "Interactions de la session",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: appColors["violet_clair"])
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Divider()
                    )
                ]
              )
            ),
            ..._detections.map((detection) => DetectionTile(
              detection: detection,
              onTap: () => Navigator.pushNamed(context, "/interaction", arguments: detection),
              showDate: false,
              showSeconds: true
            )),
          ]
        )
      ),
    );
  }
}