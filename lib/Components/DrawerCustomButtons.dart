
import 'package:flutter/material.dart';

import '../Resources/CustomSize.dart';

class DrawerCustomButtons extends StatelessWidget {
  String title;
  VoidCallback onTab;
  DrawerCustomButtons({super.key, required this.onTab,required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        width: CustomSize().customWidth(context)/1.5,
        height: CustomSize().customHeight(context)/15,
        decoration: BoxDecoration(
          color:Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(CustomSize().customWidth(context)/100),
        ),
        child: Center(
          child: Text(title,style: TextStyle(fontSize: CustomSize().customWidth(context)/20)),
        ),
      ),
    );
  }
}
