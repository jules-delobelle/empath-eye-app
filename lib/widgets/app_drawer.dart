import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget{
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        children:[
          DrawerHeader(
            child: Text("Empath Eye"),
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
            title: Text("Exercice"),
            onTap: () {Navigator.pushNamed(context, '/exercises');}
          ),
          ListTile(
            title: Text("À propos"),
            onTap: () {Navigator.pushNamed(context, '/about');}
          ),
        ]
      )
    );
  }
}
