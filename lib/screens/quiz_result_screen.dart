import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_app_bar.dart';
import '../models/quiz_result.dart';
import '../utils/colors.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  String _getMascottes(double percent) {
    if (percent < 10) return 'assets/images/mascotte/mascotte_surprise.png';
    if (percent < 30) return 'assets/images/mascotte/mascotte_tristesse.png';
    if (percent < 60) return 'assets/images/mascotte/mascotte_livre.png';
    if (percent < 80) return 'assets/images/mascotte/mascotte_pouce.png';
    return 'assets/images/mascotte/mascotte_neutre.png';
  }

  @override
  Widget build(BuildContext context) {
    final QuizResultat resultat =
        ModalRoute.of(context)!.settings.arguments as QuizResultat;
    final double scorePercent =
        resultat.scoreTotal / resultat.nombreQuestions * 100;

    return Scaffold(
      appBar: CustomAppBar(titre: "Quiz"),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                _getMascottes(scorePercent),
                height: 150,
              ),
            ),
            const SizedBox(height: 24),
            _ScoreGauge(percent: scorePercent),
            if (resultat.type == "grand_quiz") ...[
              const SizedBox(height: 32),
              Text(
                "DÉTAIL PAR ÉMOTION",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.1,
                  color: appColors['violet_clair'],
                ),
              ),
              const SizedBox(height: 16),
              ...resultat.bonnesReponsesParEmotion.entries.map((entry) {
                final double pct = entry.value /
                    resultat.questionsParEmotion[entry.key]! *
                    100;
                return _EmotionBar(
                  label: "${entry.key[0].toUpperCase()}${entry.key.substring(1)}",
                  percent: pct,
                  color: emotionColors[entry.key] ?? const Color.fromARGB(255, 197, 95, 178),
                );
              }),
            ],
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/exercises'),
                child: Text(
                  "Recommencer un entraînement",
                  style: TextStyle(
                    color: appColors['vert_fonce'],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Demi-cercle de score ─────────────────────────────────────────────────────

class _ScoreGauge extends StatefulWidget {
  final double percent;
  const _ScoreGauge({required this.percent});

  @override
  State<_ScoreGauge> createState() => _ScoreGaugeState();
}

class _ScoreGaugeState extends State<_ScoreGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "SCORE GLOBAL",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.1,
              color: appColors['violet_clair'],
            ),
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _anim,
            builder: (context, _) => CustomPaint(
              size: const Size(220, 120),
              painter: _GaugePainter(
                progress: _anim.value * widget.percent / 100,
              ),
              child: SizedBox(
                width: 220,
                height: 120,
                child: Align(
                  alignment: const Alignment(0, 1),
                  child: Text(
                    "${(_anim.value * widget.percent).round()}%",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: appColors['violet_logo'],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress; // 0.0 → 1.0

  const _GaugePainter({required this.progress});

  List<Color> get _gradientColors {
    final pct = progress * 100;
    if (pct < 40) {
      return const [Color.fromARGB(255, 240, 135, 135), Color(0xFFE24B4A)];
    } else if (pct < 70) {
      return const [Color(0xFFFAC775), Color.fromARGB(255, 239, 156, 39)];
    } else {
      return const [Color.fromARGB(255, 159, 225, 170), Color.fromARGB(255, 29, 158, 63)];
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height;
    final radius = size.width / 2 - 10;
    const startAngle = pi;
    const sweepMax = pi;

    final trackPaint = Paint()
      ..color = const Color(0xFFE8E6DF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      startAngle,
      sweepMax,
      false,
      trackPaint,
    );

    if (progress > 0) {
      final fillPaint = Paint()
        ..shader = LinearGradient(
          colors: _gradientColors,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        startAngle,
        sweepMax * progress,
        false,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.progress != progress;
}

// ── Barre d'émotion ──────────────────────────────────────────────────────────

class _EmotionBar extends StatefulWidget {
  final String label;
  final double percent;
  final Color color;

  const _EmotionBar({
    required this.label,
    required this.percent,
    required this.color,
  });

  @override
  State<_EmotionBar> createState() => _EmotionBarState();
}

class _EmotionBarState extends State<_EmotionBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 15,
                  color: appColors['violet_logo'],
                ),
              ),
              AnimatedBuilder(
                animation: _anim,
                builder: (_, __) => Text(
                  "${(_anim.value * widget.percent).round()}%",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: widget.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              height: 8,
              child: AnimatedBuilder(
                animation: _anim,
                builder: (_, __) => LinearProgressIndicator(
                  value: _anim.value * widget.percent / 100,
                  backgroundColor: const Color(0xFFE8E6DF),
                  valueColor: AlwaysStoppedAnimation(widget.color),
                  minHeight: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}