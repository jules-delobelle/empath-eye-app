import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../models/detection.dart';

class InteractionScreen extends StatefulWidget {
  const InteractionScreen({super.key});

  @override
  State<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  Detection? _detection;

  // Images placeholder (à remplacer par les vraies images)
  final List<String?> _images = [null, null, null, null];

  @override
  void initState() {
    super.initState();
    final detection =
        ModalRoute.of(context)!.settings.arguments as Detection;
    setState(() {
      _detection = detection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Interaction")),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Date & émotion ──────────────────────────────────────
            Text(
              "${_detection!.heure}",
              style: TextStyle(
                fontSize: 14,
                color: const Color.fromARGB(255, 0, 0, 0),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _detection!.emotion,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),

            const SizedBox(height: 24),

            // ── Smiley ──────────────────────────────────────────────
            const Text(
              "😄",
              style: TextStyle(fontSize: 80),
            ),

            const SizedBox(height: 28),

            // ── Encadré description ─────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 156, 199, 141),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color.fromARGB(255, 156, 199, 141),
                  width: 1.5,
                ),
              ),
              child: const Text(
                "La joie est une émotion positive intense ressentie en réponse à un événement agréable, une réussite ou une connexion sociale. "
                "Elle se distingue physiquement par un sourire spontané, souvent accompagné de plissement des yeux (sourire de Duchenne). "
                "On peut également observer une posture ouverte, des gestes plus amples et une énergie corporelle accrue. "
                "La voix devient plus dynamique et le regard s'illumine, reflétant un état intérieur de bien-être et d'enthousiasme.",
                style: TextStyle(
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
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: _images[index] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _images[index]!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 36,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Image ${index + 1}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
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