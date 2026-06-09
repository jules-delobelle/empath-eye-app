import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EmotionGraph extends StatelessWidget {
  final Map<String, int> stats;
  
  const EmotionGraph({super.key, required this.stats});

  @override
  Widget build(BuildContext context){
    return Container(
      width: double.infinity,
      height: 240,
      child: PieChart(
        PieChartData(
          sectionsSpace: 4,
          centerSpaceRadius: 35,
          sections: [
            PieChartSectionData(
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              value: (stats["surprise"] ?? 0).toDouble(),
              color: Color(0xFFA42CE0),
              radius: 60,
              title: "Suprise",
            ),
            PieChartSectionData(
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              value: (stats["colere"] ?? 0).toDouble(),
              color: Color(0xFFC72525),
              radius: 60,
              title: "Colère",
            ),
            PieChartSectionData(
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              value: (stats["tristesse"] ?? 0).toDouble(),
              color: Color(0xFF3B72E9),
              radius: 60,
              title: "Tristesse",
            ),
            PieChartSectionData(
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              value: (stats["joie"] ?? 0).toDouble(),
              color: Color(0xFFF3E243),
              radius: 60,
              title: "Joie",
            ),
          ]
        )
      )
    );  
  }
}