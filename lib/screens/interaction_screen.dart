import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_app_bar.dart';
import '../models/detection.dart';
import '../utils/colors.dart';
import '../utils/get_emotion.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class InteractionScreen extends StatefulWidget {
  const InteractionScreen({super.key});

  @override
  State<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  Detection? _detection;

List<String> _getRandomImagesForEmotion(String? emotion, {int count = 4}) {
  final rand = Random();
  final String folder = emotion?.toLowerCase() ?? 'neutre';

  // Nombre max d'images selon l'émotion
  final int maxImages = (folder == 'neutre') ? 4 : 15;

  final List<int> numbers = List.generate(maxImages, (i) => i + 1)..shuffle(rand);
  final selected = numbers.take(count).toList();

  return selected
      .map((n) => 'assets/images/$folder/$folder$n.jpg')
      .toList();
}

List<String> _emotionImages = [];

 @override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (_detection == null) {
    final detection = ModalRoute.of(context)!.settings.arguments as Detection;
    setState(() {
      _detection = detection;
      _emotionImages = _getRandomImagesForEmotion(detection.emotion);
    });
  }
}

  String _getImageForEmotion(String? emotion) {
  switch (emotion?.toLowerCase()) {
    case 'joie':
      return 'assets/images/mascotte/mascotte_joie.png';
    case 'tristesse':
      return 'assets/images/mascotte/mascotte_tristesse.png';
    case 'surprise':
      return 'assets/images/mascotte/mascotte_surprise.png';
    case 'colere':
      return 'assets/images/mascotte/mascotte_colere.png';
    case 'neutre':
      return 'assets/images/mascotte/mascotte_neutre.png';
    default:
      return 'assets/images/mascotte/mascotte_dodo.png';
  }
}

String _getDescriptionForEmotion(String? emotion) {
  switch (emotion?.toLowerCase()) {
    case 'joie':
      return "La joie est une émotion positive ressentie en réponse à un événement agréable, une réussite ou une connexion sociale. "
          "Elle se distingue physiquement par un sourire spontané, souvent accompagné de plissement des yeux. "
          "On peut également observer une posture ouverte, des gestes plus amples et une énergie corporelle accrue. "
          "La voix devient plus dynamique et le regard s'illumine, reflétant un état intérieur de bien-être et d'enthousiasme.";

    case 'tristesse':
      return "La tristesse est une émotion naturelle ressentie face à une perte, une déception ou une situation douloureuse. "
          "Elle se manifeste physiquement par un regard baissé, des coins de la bouche tombants et des paupières lourdes. "
          "La posture devient souvent voûtée, les mouvements ralentis et la voix plus douce. "
          "Des larmes peuvent apparaître, accompagnées d'une sensation de lourdeur dans la poitrine.";

    case 'surprise':
      return "La surprise est une émotion brève déclenchée par un événement inattendu, pouvant être positive ou négative. "
          "Elle se reconnaît par les sourcils levés et arqués, les yeux grands ouverts et la bouche entrouverte. "
          "Le corps réagit souvent par un léger sursaut, une inspiration soudaine et un gel momentané des mouvements. "
          "Elle est l'une des émotions les plus courtes : elle laisse rapidement place à une autre émotion selon le contexte.";

    case 'colere':
      return "La colère est une émotion forte provoquée par une frustration, une injustice ou une menace perçue. "
          "Physiquement, elle se traduit par des sourcils froncés et rapprochés, un regard intense et une mâchoire serrée. "
          "La tension musculaire augmente, le visage peut rougir, et la voix devient plus forte et plus grave. "
          "La respiration s'accélère et le corps adopte une posture de confrontation, prêt à réagir.";

    case 'neutre':
      return "L'émotion neutre se reconnaît à l'absence de tensions musculaires visibles sur le visage :"
        "les sourcils sont en position naturelle et horizontale, sans froncement ni élévation."
        "Les muscles autour des yeux sont relâchés, le regard est droit et sans plissement des paupières."
        "Le visage donne une impression d'équilibre et de calme, sans asymétrie ni mouvement expressif marqué.";
    default:
      return "Émotion non reconnue.";
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titre: "Interaction"),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Date & émotion ──────────────────────────────────────
            Text(
              DateFormat('dd/MM/yy, HH\'h\'mm' , 'fr').format(_detection!.heure!),
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              getEmotion(_detection!.emotion),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // ── Smiley ──────────────────────────────────────────────
            Image.asset(
              _getImageForEmotion(_detection?.emotion),
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),


            const SizedBox(height: 28),

            // ── Encadré description ─────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: appColors["vert_clair"],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: appColors["vert_clair"]!,
                  width: 1.5,
                ),
              ),
              child: Text(
                _getDescriptionForEmotion(_detection?.emotion),
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.6,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.justify,
              ),
            ),

            const SizedBox(height: 28),

            // ── Grille 4 images (2×2) ───────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    _emotionImages[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}