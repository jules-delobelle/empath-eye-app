import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/tiles/detection_tile.dart';
import '../widgets/tiles/session_tile.dart';
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
  bool _voirPlus = false;

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
                    "Émotions importantes",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: appColors["violet_clair"],),
                    softWrap: true,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Divider()
                    ),
                  SizedBox(width: 8),
                  Text(
                    "7 derniers jours",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: appColors["violet_clair"],)
                  ),
                ]
              )
            ),
            ..._importantDetections.take(3).map((detection) => DetectionTile(
              detection: detection,
              onTap: () => Navigator.pushNamed(context, "/interaction", arguments: detection),
              showDate: true,
              showSeconds: false
            )),
            if (_importantDetections.length > 3) 
              if(!_voirPlus)
                GestureDetector(
                  onTap: () => setState(() => _voirPlus = true),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Voir plus",
                          style: TextStyle(
                            color: appColors["violet_clair"],
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: appColors["violet_clair"],
                        ),
                      ],
                    ),
                  ),
                ),
              if(_voirPlus)
                ...[
                  ..._importantDetections.skip(3).map((detection) => DetectionTile(
                    detection: detection,
                    onTap: () => Navigator.pushNamed(context, "/interaction", arguments: detection),
                    showDate: true,
                    showSeconds: false
                  )),
                  GestureDetector(
                    onTap: () => setState(() => _voirPlus = false),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Voir moins",
                            style: TextStyle(
                              color: appColors["violet_clair"],
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_up,
                            color: appColors["violet_clair"],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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

