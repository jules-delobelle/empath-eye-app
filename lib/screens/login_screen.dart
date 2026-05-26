import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_services.dart';
import '../providers/app_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Login"),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Username"
              )
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password"
              )
            ),
            ElevatedButton(
              onPressed: () async {
                print("bouton appuyé");
                print(_usernameController.text);
                print(_passwordController.text);
                
                String? token;

                try {
                  token = await ApiServices.login(_usernameController.text, _passwordController.text);
                  print("token: $token");
                } catch(e) {
                  print("erreur: $e");
                }
                
                if(token !=  null){
                  Provider.of<AppProvider>(context, listen: false).setToken(token);
                  Navigator.pushNamed(context, "/home");
                }
                },
              child: Text("Se connecter")
            )
          ]
        ),
      )
    );
  }

  @override
  void dispose(){
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}