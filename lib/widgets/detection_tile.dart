import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/detection.dart';
import '../utils/colors.dart';
import '../utils/get_emotion.dart';


class DetectionTile extends StatelessWidget{
  final Detection? detection;
  final VoidCallback onTap;
  final bool showDate;
  final bool showSeconds;

  const DetectionTile({super.key, this.detection, required this.onTap, required this.showDate, required this.showSeconds});
  
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
        height: 48,
        decoration: BoxDecoration(
          color: appColors["vert_clair"],
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: double.infinity,
              width: 90,
              decoration: BoxDecoration(
                color: emotionColors[detection!.emotion] ?? Colors.grey,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))
              ),
              child: Text(
                getEmotion(detection!.emotion),
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
              )
            ),
            SizedBox(width: 8),
            Text(showDate 
              ? DateFormat('dd/MM/yyyy, HH\'h\'mm', 'fr').format(detection!.heure!)
              : showSeconds 
                  ? DateFormat('HH\'h\'mm\'m\'ss\'s\'', 'fr').format(detection!.heure!)
                  : DateFormat('HH\'h\'mm', 'fr').format(detection!.heure!)
            ),
            Spacer(),
            Icon(Icons.chevron_right, color: appColors["vert_fonce"], size: 30),
            SizedBox(width: 8)
          ]
        )
      )
    );
  }
}