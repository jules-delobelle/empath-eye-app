import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../services/api_services.dart';
import '../providers/app_provider.dart';
import '../models/enfant.dart';
import '../models/session.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
  
}

class _HistoryScreenState extends State<HistoryScreen> {

  String? token;
  List<Session> _sessions = [];

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
        final history = await ApiServices.getSessions(token!, enfant.idEnfant);
        if(history != null && mounted) {
          setState(() {_sessions = history;});
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
      appBar: AppBar(title: Text("Historique")),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: _sessions.length,
        itemBuilder: (context, index) {
          Session session = _sessions[index];
          return ListTile(
            title: Text("${session.date}"),
            onTap:() => Navigator.pushNamed(context, '/session', arguments: session),
          );
        }
      ),
    );

}
}