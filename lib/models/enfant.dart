class Enfant{
  int idEnfant;
  int idUser;
  DateTime? naissance;
  String prenom;
  DateTime? dernierTelechargement;

  Enfant({
    required this.idEnfant, 
    required this.idUser, 
    required this.naissance, 
    required this.prenom,
    required this.dernierTelechargement
    });

  factory Enfant.fromJson(Map<String, dynamic> json){
    return Enfant(
      idEnfant: json['id_enfant'], 
      idUser: json['id_user'], 
      prenom: json['prenom'], 
      naissance: json['naissance'] != null ? DateTime.parse(json['naissance']) : null,
      dernierTelechargement: 
        json['dernier_telechargement'] != null 
        ? DateTime.parse(json['dernier_telechargement'])
        : null,
      );
  }
}