import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_services.dart';
import '../providers/app_provider.dart';

class AppDrawer extends StatefulWidget{
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>{

  String? token;

  @override
  void initState(){
    super.initState();
    _loadEnfants();
  }

  Future<void> _loadEnfants() async {
    token = await ApiServices.getToken();
    if(token != null){
      final enfants = await ApiServices.getEnfants(token!);
      if (enfants != null && mounted) Provider.of<AppProvider>(context, listen: false).setEnfants(enfants);
    }
  }

  @override
  Widget build(BuildContext context){
    final enfants = Provider.of<AppProvider>(context).getEnfants();
    return Drawer(
      child: Column(
        children:[
          DrawerHeader(
            child: Text("Empath'Eye"),
          ),
          ListTile(
            title: Text("Accueil"),
            onTap: () {Navigator.pushNamed(context, '/home');}
          ),
          ListTile(
            title: Text("Historique"),
            onTap: () {Navigator.pushNamed(context, '/history');}
          ),
          ListTile(
            title: Text("Exercices"),
            onTap: () {Navigator.pushNamed(context, '/exercises');}
          ),
          ListTile(
            title: Text("À propos"),
            onTap: () {Navigator.pushNamed(context, '/about');}
          ),
          Spacer(),
          ExpansionTile(
            title: Text(
                Provider.of<AppProvider>(context, listen: false).getEnfantSelectionne() == null
                    ? "Non sélectionné"
                    : Provider.of<AppProvider>(context, listen: false)
                        .getEnfantSelectionne()!
                        .prenom,
              ),
            subtitle: Text("Cliquez pour changer d'enfant"),
            children: [
              ...enfants.map((enfant) => ListTile(
                title: Text(enfant.prenom),
                onTap: () {
                  Provider.of<AppProvider>(context, listen: false).setEnfantSelectionne(enfant);
                  ApiServices.saveEnfantId(enfant);
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Confirmation"),
                        content: Text("Êtes-vous sur de vouloir supprimer ${enfant.prenom}"),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Annuler")
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await ApiServices.deleteEnfant(token, enfant.idEnfant);
                              Navigator.pop(context);
                              _loadEnfants();
                              },
                              child: Text("Supprimer")
                          )
                        ]
                      )
                    );
                  }
                )
              ),
            ),
            ListTile(
              title: Text("+"),
              onTap: () => Navigator.pushNamed(context, "/create_enfant"),
              )
            ]
            ),
          ListTile(
            title: Text("Déconnexion"),
            onTap: () {
              ApiServices.deleteToken();
              Provider.of<AppProvider>(context, listen: false).logOut();
              Navigator.pushNamed(context, '/login');
            }
          )
        ]
      )
    );
  }
}
