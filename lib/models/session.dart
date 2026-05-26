class Session{
  int idSession;
  int idEnfant;
  DateTime? date;

  Session({required this.idSession, required this.idEnfant, required this.date});

  factory Session.fromJson(Map<String, dynamic> json){
    return Session(
      idSession: json['id_session'], 
      idEnfant: json['id_enfant'],  
      date: json['date'] != null ? DateTime.parse(json['date']) : null,);
  }
}