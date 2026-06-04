import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/enfant.dart';
import '../models/detection.dart';
import '../models/session.dart';

class ApiServices {
  static const baseUrl = "http://10.0.2.2:8000/api";
  static const _storage = FlutterSecureStorage();

  static Future<String?> login(String username, String password) async{
    final response = await http.post(
      Uri.parse("$baseUrl/token/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password})
    );
    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      await saveToken(data["access"]);
      return data["access"];
    } else{
      return null;
    }
  }

  static Future<bool?> register(String username, String password) async{
    final response = await http.post(
      Uri.parse("$baseUrl/register/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password})
    );
    if (response.statusCode == 201){
      return true;
    }
    return false;
  }

  //Enfants

  static Future<List<Enfant>?> getEnfants(String token) async{
    final response = await http.get(
      Uri.parse("$baseUrl/enfant/"),
      headers: {"Content-Type": "application/json", 
                "Authorization": "Bearer $token"},
    );
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data.map<Enfant>((item) => Enfant.fromJson(item)).toList();
    }else{
      return null;
    }
  }

  static Future<bool?> createEnfant(String token, String prenom, DateTime? naissance) async{
    final response = await http.post( 
      Uri.parse("$baseUrl/enfant/"),
      headers: {"Content-Type": "application/json",
                "Authorization": "Bearer $token"},
      body: jsonEncode({"prenom": prenom, "naissance": naissance != null ? "${naissance.year}-${naissance.month.toString().padLeft(2, '0')}-${naissance.day.toString().padLeft(2, '0')}" : null})
    );
    if(response.statusCode == 201){
      return true;
    }
    return false;
  }

  static Future<bool?> deleteEnfant(String? token, int id) async{
    final response = await http.delete(
      Uri.parse("$baseUrl/enfant/$id/"),
      headers: {"Content-Type": "application/json",
                "Authorization": "Bearer $token"},
    );
    if(response.statusCode == 204){
      return true;
    }
    return false;
  }

  static Future<void> updateDernierTelechargement(String? token, int id) async{
    final response = await http.patch(
      Uri.parse("$baseUrl/enfant/$id/"),
      headers: {"Content-Type": "application/json",
                "Authorization": "Bearer $token"},
      body: jsonEncode({
        "dernier_telechargement": DateTime.now().toIso8601String()
      })
    );
  }

  //Sessions

  static Future<List<Session>?> getSessions(String token, int enfantId) async{
    final response = await http.get(
      Uri.parse("$baseUrl/session/?enfant=$enfantId"),
      headers: {"Content-Type": "application/json",
                "Authorization": "Bearer $token"}
    );
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data.map<Session>((item) => Session.fromJson(item)).toList();
    }else{
      return null;
    }
  }

  static Future<Session?> createSession(String token, DateTime date, int enfantID) async{
    final response = await http.post(
      Uri.parse("$baseUrl/session/"),
      headers: {"Content-Type": "application/json",
                "Authorization": "Bearer $token"},
      body: jsonEncode({"id_enfant": enfantID, "date": date.toIso8601String().split('T')[0]})
    );
    if(response.statusCode == 201){
      final data = jsonDecode(response.body);
      return Session.fromJson(data);
    }
    return null;
  }

  //Detections

  static Future<List<Detection>?> getDetections(String token, int sessionId) async{
    final response = await http.get(
      Uri.parse("$baseUrl/detection/?session=$sessionId"),
      headers: {"Content-Type":"application/json",
                "Authorization": "Bearer $token"}
    );
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data.map<Detection>((item) => Detection.fromJson(item)).toList();
    }else{
      return null;
    }
  }

  static Future<bool?> createDetection(String token, int sessionID, String emotion, DateTime heure, bool important) async{
    final response = await http.post(
      Uri.parse("$baseUrl/detection/"),
      headers: {"Content-Type":"application/json",
                "Authorization": "Bearer $token"},
      body: jsonEncode({"id_session": sessionID, "emotion": emotion, "heure": heure.toIso8601String(), "important": important})
    );
    if(response.statusCode == 201){
      return true;
    }
    return false;
  }

  static Future<List<Detection>?> getImportantDetections(String token) async{
    final response = await http.get(
      Uri.parse(("$baseUrl/detection/?important=true")),
      headers : {"Content-Type":"application/json",
                 "Authorization": "Bearer $token"}
    );
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data.map<Detection>((item) => Detection.fromJson(item)).toList();
    }else{
      return null;
    }
  }

  //Stats

  static Future<Map<String, int>?> getStats(String token, int enfantId) async{
    final response = await http.get(
      Uri.parse("$baseUrl/stats/?enfant=$enfantId"),
      headers: {"Content-Type": "application/json",
                "Authorization": "Bearer $token"}
    );
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return Map<String, int>.from(data);
    }
    return null;
  }

  static Future<void> saveToken(String token) async{
    await _storage.write(key: "access_token", value: token);
  }

  static Future<String?> getToken() async{
    return await _storage.read(key: "access_token");
  }

  static Future<void> deleteToken() async{
    await _storage.delete(key: "access_token");
  }

  static Future<void> saveEnfantId(Enfant enfant) async{
    await _storage.write(key: "enfant_id", value: enfant.idEnfant.toString());
  }

  static Future<int?> getEnfantId() async{
    String? valeur = await _storage.read(key: "enfant_id");
    return valeur != null ? int.parse(valeur) : null;
  }
}

