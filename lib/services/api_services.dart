import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  static Future<List?> getEnfant(String token) async{
    final response = await http.get(
      Uri.parse("$baseUrl/enfant/"),
      headers: {"Content-Type": "application/json", 
                "Authorization": "Bearer $token"}
    );
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data;
    }else{
      return null;
    }
  }

  static Future<List?> getSessions(String token, int enfantId) async{
    final response = await http.get(
      Uri.parse("$baseUrl/session/?enfant=$enfantId"),
      headers: {"Content-Type": "application/json",
                "Authorization": "Bearer $token"}
    );
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data;
    }else{
      return null;
    }
  }

  static Future<List?> getDetections(String token, int sessionId) async{
    final response = await http.get(
      Uri.parse("$baseUrl/detection/?session=$sessionId"),
      headers: {"Content-Type":"application/json",
                "Authorization": "Bearer $token"}
    );
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data;
    }else{
      return null;
    }
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
}

