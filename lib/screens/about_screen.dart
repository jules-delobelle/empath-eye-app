import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("À propos")),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            const Center(
              child: Text(
                "À PROPOS",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Ligne 1 : texte à gauche, image à droite
            _buildRow(
              context,
              text: "Nous sommes une équipe de 6 élèves en troisième année d'école d'ingénieur à l'ESIEE Paris."
                    " Empath'eye vise à aider les enfants autistes à analyser les émotions grâce à des lunettes intelligentes.",
              imageOnRight: true,
            ),
            const SizedBox(height: 24),

            // Ligne 2 : image à gauche, texte à droite
            _buildRow(
              context,
              text: "Nos lunettes intelligentes capturent des images à l'aide d'une caméra, "
                    "elles sont ensuite traitées par une IA et l'émotion détectée est communiquée via une LED.",
              imageOnRight: false,
            ),
            const SizedBox(height: 24),

            // Ligne 3 : texte à gauche, image à droite
            _buildRow(
              context,
              text: "L'application permet aux parents de surveiller les progrès "
                    "et à l'enfant de s'entraîner à détecter les émotions tout seul.",
              imageOnRight: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, {required String text, required bool imageOnRight}) {
    final textWidget = Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF9CC78D),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );

    final imageWidget = Expanded(
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(Icons.image, size: 48, color: Colors.grey),
        ),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: imageOnRight
          ? [textWidget, const SizedBox(width: 16), imageWidget]
          : [imageWidget, const SizedBox(width: 16), textWidget],
    );
  }
}