import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/detection_tile.dart';
import '../widgets/session_tile.dart';
import '../widgets/custom_app_bar.dart';
import '../services/api_services.dart';
import '../providers/app_provider.dart';
import '../models/enfant.dart';
import '../models/session.dart';
import '../models/detection.dart';
import '../utils/colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
  
}

class _HistoryScreenState extends State<HistoryScreen> {

  String? token;
  List<Session> _sessions = [];
  List<Detection> _importantDetections = [];

  @override
  void initState(){
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    token = await ApiServices.getToken();
    if(token != null){
      Enfant? enfant = Provider.of<AppProvider>(context, listen: false).getEnfantSelectionne();
      if(enfant != null) {
        DateTime limite = DateTime.now().subtract(Duration(days: 7));
        final history = await ApiServices.getSessions(token!, enfant.idEnfant);
        final rawDetections = await ApiServices.getImportantDetections(token!);
        if(rawDetections != null && history != null && mounted){
          final importantDetections = rawDetections.where((d) => d.heure!.isAfter(limite)).toList();
          history.sort((a, b) => b.date!.compareTo(a.date!));
          importantDetections.sort((a, b) => b.heure!.compareTo(a.heure!));
          setState(() {_sessions = history; _importantDetections = importantDetections;});
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Aucun enfant n'est sélectionné"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titre: "Historique"),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children:[
                  Text(
                    "Interactions importantes des 7 derniers jours",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: appColors["violet_clair"],),
                    softWrap: true,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Divider()
                    )
                ]
              )
            ),
            ..._importantDetections.take(3).map((detection) => DetectionTile(
              detection: detection,
              onTap: () => Navigator.pushNamed(context, "/interaction", arguments: detection),
              showDate: true,
              showSeconds: false
            )),
            if (_importantDetections.length > 3 )ExpansionTile(
              title: Text("Voir plus"),
              children: [
                ..._importantDetections.skip(3).map((detection) => DetectionTile(
                  detection: detection,
                  onTap: () => Navigator.pushNamed(context, "/interaction", arguments: detection),
                  showDate: true,
                  showSeconds: false
                ))
              ]
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children:[
                  Text(
                    "Sessions",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: appColors["violet_clair"])
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Divider()
                    )
                ]
              )
            ),
            ..._sessions.map((session) => SessionTile(
              session: session,
              onTap:() => Navigator.pushNamed(context, '/session', arguments: session) 
            ))
          ]
        )
      )
    );
  }
}

