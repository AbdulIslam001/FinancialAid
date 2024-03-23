
import 'package:financial_aid/Models/ApplicationModel.dart';
import 'package:financial_aid/Resources/CustomSize.dart';
import 'package:flutter/material.dart';

import '../../Components/CustomButton.dart';

class ApplicationDetails extends StatelessWidget {
  Application application;
  ApplicationDetails({super.key,required this.application});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Application detail"),centerTitle: true,backgroundColor: Theme.of(context).primaryColor),
      body: Column(
        children: [
          Container(
            height: CustomSize().customHeight(context)/3,
            width: CustomSize().customWidth(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(CustomSize().customHeight(context)/30),bottomRight: Radius.circular(CustomSize().customHeight(context)/30)),
              border:Border.all()
            ),
            child:const Center(child: Image(image: AssetImage("Assets/c1.png"))) ,
          ),
          Text(application.name,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),),
          Text(application.aridNo,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),),
          Padding(
            padding: EdgeInsets.only(top: CustomSize().customHeight(context)/5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(title: "Reject",loading: false,onTap: (){}),
                SizedBox(
                  width: CustomSize().customWidth(context)/10,
                ),
                CustomButton(title: "Accept",loading: false,onTap: (){}),

              ],
            ),
          )
        ],
      ),
    );
  }
}
