import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String? titre;

  const CustomAppBar({super.key, this.titre});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context){
    return AppBar(
      title: titre != null ? Text(titre!, style : TextStyle(color: appColors['violet_logo'])) : null,
      actions: [
        Image.asset("assets/images/logo/logo.png"),
        SizedBox(width: 8)
      ]
    );
  }

}