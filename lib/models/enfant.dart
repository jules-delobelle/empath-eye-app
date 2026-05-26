class Enfant{
  int idEnfant;
  int idUser;
  DateTime? naissance;
  String prenom;

  Enfant({required this.idEnfant, required this.idUser, required this.naissance, required this.prenom});

  factory Enfant.fromJson(Map<String, dynamic> json){
    return Enfant(
      idEnfant: json['id_enfant'], 
      idUser: json['id_user'], 
      prenom: json['prenom'], 
      naissance: json['naissance'] != null ? DateTime.parse(json['naissance']) : null,);
  }
}