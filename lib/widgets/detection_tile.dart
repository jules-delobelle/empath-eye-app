import 'package:flutter/material.dart';

import '../models/detection.dart';
import '../utils/colors.dart';


class DetectionTile extends StatelessWidget{
  final Detection? detection;
  final VoidCallback onTap;

  const DetectionTile({super.key, this.detection, required this.onTap});
  
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: appColors["vert_clair"],
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: 40,
              decoration: BoxDecoration(
                color: emotionColors[detection!.emotion] ?? Colors.grey,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))
              )
            ),
            SizedBox(width: 8),
            Text("${detection!.heure} | ${detection!.emotion}")
          ]
        )
      )
    );
  }
}