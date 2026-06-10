import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/session.dart';
import '../utils/colors.dart';


class SessionTile extends StatelessWidget{
  final Session? session;
  final VoidCallback onTap;

  const SessionTile({super.key, this.session, required this.onTap});
  
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
            SizedBox(width: 12),
            Text(DateFormat('dd MMMM yyyy', 'fr').format(session!.date!)),
            Spacer(),
            Icon(Icons.chevron_right, color: appColors["vert_fonce"], size: 30),
            SizedBox(width: 8)
          ]
        )
      )
    );
  }
}