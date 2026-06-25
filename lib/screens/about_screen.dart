import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titre: "À propos"),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            Center(
              child: Text(
                "À PROPOS",
                style: TextStyle(
                  color: appColors['violet_logo'],
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
                    " Empath'Eye vise à aider les enfants autistes à analyser les émotions grâce à des lunettes intelligentes.",
              imagePath: "assets/images/logo/logo_esiee.png",
              imageOnRight: true,
            ),
            const SizedBox(height: 24),

            // Ligne 2 : image à gauche, texte à droite
            _buildRow(
              context,
              text: "Nos lunettes intelligentes capturent des images à l'aide d'une caméra, "
                    "elles sont ensuite traitées par une IA et l'émotion détectée est communiquée via une LED.",
              imagePath: "assets/images/lunettes/lunettes.jpg",
              imageOnRight: false,
            ),
            const SizedBox(height: 24),

            // Ligne 3 : texte à gauche, image à droite
            _buildRow(
              context,
              text: "L'application permet aux parents de surveiller les progrès "
                    "et à l'enfant de s'entraîner à détecter les émotions tout seul.",
              imagePath: "assets/images/icon/icon.png",
              imageOnRight: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, {
    required String text,
    required String imagePath,
    required bool imageOnRight,
  }) {
    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 110,
        height: 110,
        color: Colors.grey.shade300,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );

    final textWidget = Expanded(
      flex: 3,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: appColors['violet_logo'],
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors["vert_clair"],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: imageOnRight
            ? [textWidget, const SizedBox(width: 12), imageWidget]
            : [imageWidget, const SizedBox(width: 12), textWidget],
      ),
    );
  }
}