import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier{
  String? _token;
  Map? _enfantSelectionne;

  String? getToken(){
    return _token;
  }

  Map? getEnfantSelectionne(){
    return _enfantSelectionne;
  }

  void setToken(String? token){
    _token = token;
    notifyListeners();
  }

  void setEnfantSelectionne(Map? enfantSelectionne){
    _enfantSelectionne = enfantSelectionne;
    notifyListeners();
  }

  void logOut(){
    _token = null;
    _enfantSelectionne = null;
    notifyListeners();
  }
}