import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EmotionGraph extends StatelessWidget {
  const EmotionGraph({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 40,
              color: Color(0xFFA42CE0),
              title: "Suprise",
            ),
            PieChartSectionData(
              value: 10,
              color: Color(0xFFC72525),
              title: "Colère",
            ),
            PieChartSectionData(
              value: 20,
              color: Color(0xFF3B72E9),
              title: "Tristesse",
            ),
            PieChartSectionData(
              value: 30,
              color: Color(0xFFF3E243),
              title: "Joie",
            ),
          ]
        )
      )
    );  
  }

}