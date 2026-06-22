import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../widgets/app_drawer.dart';
import '../widgets/connexion/connexion_card.dart';
import '../widgets/connexion/connexion_dialog.dart';
import '../widgets/emotion_graph.dart';
import '../widgets/custom_app_bar.dart';
import '../models/enfant.dart';
import '../models/session.dart';
import '../providers/app_provider.dart';
import '../services/ble_service.dart';
import '../services/api_services.dart';
import '../utils/colors.dart';

enum EtatConnexion { recherche, connecte, transfert, termine, erreur }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
} 

class _HomeScreenState extends State<HomeScreen>{
  EtatConnexion _etat = EtatConnexion.recherche;
  Map<String, int> _stats = {"joie": 0, "tristesse": 0, "colere": 0, "surprise": 0};
  StateSetter? _setDialogState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadStats();
  }

  void _ouvrirDialog(){
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder : (context, setDialogState) {
            _setDialogState = setDialogState;
            return ConnexionDialog(
              etat: _etat,
              onAnnuler: () => Navigator.pop(context),
              onReessayer: () {
                Navigator.pop(context);
                _telecharger();
              }
          );
        }
      ) 
    );
  }

  Future<void> _loadStats() async{
    String? token = await ApiServices.getToken();
    Enfant? enfant = Provider.of<AppProvider>(context, listen: false).getEnfantSelectionne();
    if(token != null && enfant != null){
      Map<String, int>? stats = await ApiServices.getStats(token, enfant.idEnfant);
      if(stats != null){
        setState(() => _stats = stats);
      }
    }
  }

  Map<String, Session> _sessionCache = {};

  Future<Session?> _getOuCreerSession(
      String token, int idEnfant, DateTime date, List<Session> sessions) async {
    String cle = "${date.year}-${date.month}-${date.day}";

    if (_sessionCache.containsKey(cle)) {
      return _sessionCache[cle];
    }

    for (var session in sessions) {
      if (session.date != null &&
          session.date!.year == date.year &&
          session.date!.month == date.month &&
          session.date!.day == date.day) {
        _sessionCache[cle] = session;
        return session;
      }
    }

    Session? nouvelleSession = await ApiServices.createSession(token, date, idEnfant);
    if (nouvelleSession != null) {
      sessions.add(nouvelleSession);
      _sessionCache[cle] = nouvelleSession;
    }
    return nouvelleSession;
  }

  void _telecharger() async{
    String? token = await ApiServices.getToken();
    Enfant? enfant = Provider.of<AppProvider>(context, listen: false).getEnfantSelectionne();

    if(token == null || enfant == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement"))
      );
      return;
    }

    setState(() {_etat = EtatConnexion.recherche;});
    _ouvrirDialog();

    print("Début du scan...");
    List<ScanResult> appareils = await BLEService.scanDevices();
    print("Scan terminé, ${appareils.length} appareil(s) trouvé(s)");
    ScanResult? lunettes;
    for (var appareil in appareils) {
      print("   → ${appareil.device.platformName} (${appareil.device.remoteId})");
      if (appareil.device.platformName.startsWith("EmpathEye"))  {
          lunettes = appareil;
          break;
        }
    }
    if (lunettes == null) {
      print("Lunettes introuvables");
      setState(() {_etat = EtatConnexion.erreur;});
      _setDialogState?.call(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lunettes introuvables"))
      );
      return;
    }

    setState(() {_etat = EtatConnexion.connecte;});
    _setDialogState?.call(() {});

    print("Lunettes trouvées, connexion...");
    await BLEService.connect(lunettes.device);
    print("Connecté, envoi de REQUEST_FILES...");
    await BLEService.sendCommand(lunettes.device, "REQUEST_FILES");
    setState(() {_etat = EtatConnexion.transfert;});
    print("Commande envoyée, écoute du transfert...");

    List<int> buffer = [];
    int tailleAttendue = 0;
    List<Session>? sessions = await ApiServices.getSessions(token, enfant.idEnfant);

    if (sessions == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de session"))
      );
      return;
    }

    _sessionCache = {};

    List<int> bufferTotal = [];
    int compteurPaquets = 0;

    await for (var paquet in BLEService.listenTransfer(lunettes.device)) {
      compteurPaquets++;
      print("--- Paquet #$compteurPaquets reçu, taille: ${paquet.length} ---");
      
      bool estFinDeTransfert = false;

      try {
        String decoded = utf8.decode(paquet);
        print("Décodage UTF8 réussi: $decoded");
        
        dynamic json = jsonDecode(decoded);
        print("jsonDecode réussi, type: ${json.runtimeType}");
        
        if (json is Map && json["name"] == "__END__") {
          print("→ Marqueur __END__ détecté !");
          estFinDeTransfert = true;
        } else {
          print("→ JSON valide mais pas __END__ (probablement métadonnée ou fichier complet en 1 chunk)");
        }
      } catch (e) {
        print("→ Pas du JSON valide (chunk binaire), erreur: $e");
      }

      if (estFinDeTransfert) {
        print("Fin du transfert, sortie de la boucle");
        break;
      } else {
        bufferTotal.addAll(paquet);
        print("→ Ajouté au buffer. Taille buffer total: ${bufferTotal.length}");
      }
    }

    print("=== Boucle terminée ===");
    print("Nombre total de paquets reçus: $compteurPaquets");
    print("Taille finale du buffer: ${bufferTotal.length} octets");

    try {
      String texteComplet = utf8.decode(bufferTotal);
      print("Buffer décodé en texte (${texteComplet.length} caractères):");
      print(texteComplet);
      
      List<dynamic> detections = jsonDecode(texteComplet);
      print("JSON parsé avec succès ! Nombre de détections: ${detections.length}");
      
      for (var i = 0; i < detections.length; i++) {
        var detectionJson = detections[i];
        print("--- Traitement détection #${i + 1}: $detectionJson ---");
        
        String timestamp = detectionJson["timestamp"];
        DateTime heure = DateTime(
          int.parse(timestamp.substring(0, 4)),
          int.parse(timestamp.substring(4, 6)),
          int.parse(timestamp.substring(6, 8)),
          int.parse(timestamp.substring(9, 11)),
          int.parse(timestamp.substring(11, 13)),
          int.parse(timestamp.substring(13, 15)),
        );
        print("→ Timestamp parsé: $heure");

        Session? sessionPourCetteDetection = await _getOuCreerSession(token, enfant.idEnfant, heure, sessions);

        if (sessionPourCetteDetection == null) {
          print("Impossible de créer/trouver la session pour cette date");
          continue;
        }

        bool? success = await ApiServices.createDetection(
          token,
          sessionPourCetteDetection.idSession,
          detectionJson["emotion"],
          heure,
          detectionJson["saved?"] ?? false
        );
        print("→ Résultat de la création: $success");
      }
      print("=== Toutes les détections ont été créées avec succès ===");
    } catch (e) {
      print("ERREUR lors du traitement des détections : $e");
    }
    print("Transfert terminé");
    await BLEService.sendCommand(lunettes.device, "TRANSFER_OK");
    print("Envoi de TRANSFER_OK");
    await BLEService.disconnect(lunettes.device);
    print("Deconnecté");

    setState(() {_etat = EtatConnexion.termine;});

    await ApiServices.updateDernierTelechargement(token, enfant.idEnfant);

    final enfants = await ApiServices.getEnfants(token);
    if (enfants != null && mounted) {
        Provider.of<AppProvider>(context, listen: false).setEnfants(enfants);
        
        final enfantMisAJour = enfants.firstWhere((e) => e.idEnfant == enfant.idEnfant);
        Provider.of<AppProvider>(context, listen: false).setEnfantSelectionne(enfantMisAJour);
    }


    await _loadStats();
    await Future.delayed(Duration(seconds: 2));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Enfant? enfant = Provider.of<AppProvider>(context).getEnfantSelectionne();
    return Scaffold(
      appBar: CustomAppBar(titre: "Accueil"),
      drawer: AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          RichText(
            text: TextSpan(
              style: TextStyle(color: appColors["violet_logo"], fontSize: 18),
              children: [
                TextSpan(text: "Bienvenue "),
                TextSpan(
                    text: enfant?.prenom ?? '...',
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),
                TextSpan(text: " sur Empath'Eye"),
              ]
            )
          ),
          SizedBox(height: 16),
          ConnexionCard(
            onTelecharger: () {
              setState(() {_etat = EtatConnexion.recherche;});
              _telecharger();
            },
            dernierTelechargement: enfant?.dernierTelechargement
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Émotions rencontrées sur les 7 dernières sessions :", style: TextStyle(fontSize: 13))
          ),
          SizedBox(height: 10,),
          EmotionGraph(stats: _stats),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(color: appColors["violet_logo"], fontSize: 16),
              children: [
                TextSpan(text: "Prêt à "),
                TextSpan(
                    text: "progresser ",
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),
                TextSpan(text: "aujourd'hui ?"),
              ]
            )
          ),
          SizedBox(height: 8,),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/exercises'),
                      child: Text("Viens t'entraîner !", style: TextStyle(fontSize: 18, color: appColors["vert_fonce"]))
                  )
              )
          )
        ]
      ),
    );
  }
}