
import 'package:flutter/material.dart';

import '../Resources/CustomSize.dart';

class OptionContainer extends StatelessWidget {
  String title;
  String image;
  final VoidCallback onTap;
  OptionContainer({super.key , required this.image,required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(CustomSize().customHeight(context)/80),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: CustomSize().customHeight(context)/5,
          width: CustomSize().customWidth(context)/2.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/80),
            color: Colors.blueGrey.withOpacity(0.2),
//            color: Colors.white.withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: CustomSize().customHeight(context)/1000,
                blurRadius: CustomSize().customHeight(context)/100,
                offset: Offset(CustomSize().customHeight(context)/1400,
                    CustomSize().customHeight(context)/1400),
              ),
            ],
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image:AssetImage(image),fit: BoxFit.fill,
                height: CustomSize().customHeight(context)/10,
                width: CustomSize().customWidth(context)/3.5,),
              Padding(
                padding: EdgeInsets.only(left:CustomSize().customWidth(context)/20),
                child: Text(title,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
