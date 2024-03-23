
import 'package:financial_aid/Models/ApplicationModel.dart';
import 'package:flutter/material.dart';

import '../Resources/CustomSize.dart';
import '../Views/Committee/ApplicationDetails.dart';

class ApplicationView extends StatelessWidget {
  List<App> application;
  ApplicationView({super.key , required this.application});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: application.length,
      itemBuilder: (context, index) {
      return Padding(
        padding: EdgeInsets.all(CustomSize().customHeight(context)/80),
        child: Center(
          child: GestureDetector(
            onTap: (){
             /* Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ApplicationDetails(application: application[index],);
              },));*/
            },
            child: Container(
              height: CustomSize().customHeight(context)/4.5,
              width: CustomSize().customWidth(context)/1.13,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/80),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: CustomSize().customHeight(context)/8,
                    width: CustomSize().customWidth(context)/1.12,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/80),
                    ),
                    child:const Image(image: AssetImage("Assets/c1.png"),fit: BoxFit.contain),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:CustomSize().customHeight(context)/80,top:CustomSize().customHeight(context)/80 ),
                    child:Text(application[index].name,style: TextStyle(fontSize: CustomSize().customHeight(context)/50,fontStyle: FontStyle.italic),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:CustomSize().customHeight(context)/80,top:CustomSize().customHeight(context)/80 ),
                    child:Text(application[index].aridNumber,style: TextStyle(fontSize: CustomSize().customHeight(context)/50,fontStyle: FontStyle.italic),),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },);
  }
}
