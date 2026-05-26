class Detection{
  int idDetection;
  int idSession;
  DateTime? heure;
  String emotion;
  bool important;

  Detection({required this.idDetection, required this.idSession, required this.heure, required this.emotion, required this.important});

  factory Detection.fromJson(Map<String, dynamic> json){
    return Detection(
      idDetection: json['id_detection'], 
      idSession: json['id_session'], 
      emotion: json['emotion'],
      important: json['important'],
      heure: json['heure'] != null ? DateTime.parse(json['heure']) : null,
      );
  }
}