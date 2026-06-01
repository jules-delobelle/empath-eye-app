import 'package:flutter/material.dart';

import '../services/api_services.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordValidController = TextEditingController();

  Future<void> _handleRegister() async{
    bool? result;

    if(_passwordController.text == _passwordValidController.text){
      result = await ApiServices.register(
        _usernameController.text,
        _passwordController.text  
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Les mots de passe sont différents"),
          backgroundColor: Colors.redAccent,
        )
      );
      return;
    }
    
    if(result == true){
      Navigator.pushNamed(context, "/login");
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur lors de la création du compte"),
          backgroundColor: Colors.redAccent,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Créer un compte"),
              const SizedBox(height: 32),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nom d'utilisateur",
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Mot de passe"
                )
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordValidController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Valider le mot de passe"
                )
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleRegister,
                  child: const Text('Créer un compte')
                ),
              ),
            ]
          )
        )
      )
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordValidController.dispose();
    super.dispose();
  }
}

