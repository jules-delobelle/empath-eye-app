import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/detection.dart';
import '../utils/colors.dart';


class DetectionTile extends StatelessWidget{
  final Detection? detection;
  final VoidCallback onTap;
  final bool showDate;

  const DetectionTile({super.key, this.detection, required this.onTap, required this.showDate});
  
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        height: 48,
        decoration: BoxDecoration(
          color: appColors["vert_clair"],
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: 90,
              decoration: BoxDecoration(
                color: emotionColors[detection!.emotion] ?? Colors.grey,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))
              ),
              child: Text(
                detection!.emotion,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
              )
            ),
            SizedBox(width: 8),
            Text(showDate 
              ? DateFormat('dd/MM/yyyy, HH\'h\'mm', 'fr').format(detection!.heure!)
              : DateFormat('HH\'h\'mm', 'fr').format(detection!.heure!)
            )
          ]
        )
      )
    );
  }
}