import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_services.dart';
import '../providers/app_provider.dart';

class AppDrawer extends StatelessWidget{
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context){
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
