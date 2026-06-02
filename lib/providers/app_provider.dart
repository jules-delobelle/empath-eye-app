import 'package:flutter/material.dart';

import '../models/enfant.dart';

class AppProvider extends ChangeNotifier{
  String? _token;
  Enfant? _enfantSelectionne;
  List<Enfant> _enfants = [];

  AppProvider({Enfant? enfantInitial}){
    _enfantSelectionne = enfantInitial;
  }

  String? getToken(){
    return _token;
  }

  Enfant? getEnfantSelectionne(){
    return _enfantSelectionne;
  }

  List<Enfant> getEnfants(){
    return _enfants;
  }

  void setToken(String? token){
    _token = token;
    notifyListeners();
  }

  void setEnfantSelectionne(Enfant? enfantSelectionne){
    _enfantSelectionne = enfantSelectionne;
    notifyListeners();
  }

  void setEnfants(List<Enfant> enfants){
    _enfants = enfants;
    notifyListeners();
  }

  void logOut(){
    _token = null;
    _enfantSelectionne = null;
    notifyListeners();
  }
}