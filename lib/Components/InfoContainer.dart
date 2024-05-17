
import 'package:financial_aid/viewModel/StudentViewModel/StudentInfoViewModel.dart';
import 'package:flutter/material.dart';

import '../Resources/CustomSize.dart';

class InfoContainer extends StatelessWidget {
  String name;
  String aridNo;
  String status;
  InfoContainer({super.key, required this.name,required this.aridNo,required this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only( top: CustomSize().customHeight(context)/45),
      child: Center(
        child: Container(
          height: CustomSize().customHeight(context)/4,
          width: CustomSize().customWidth(context)/1.13,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/80),
            color: Colors.blueGrey.withOpacity(0.2),
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
          child:Column(
            children: [
              Center(child: Text("Welcome                 ",style: TextStyle(fontSize: CustomSize().customHeight(context)/30,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
              Padding(
                padding: EdgeInsets.only(left:CustomSize().customWidth(context)/4),
                child: Center(child:Text(name,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),)),
              ),
              Padding(
                padding: EdgeInsets.only(left:CustomSize().customWidth(context)/4),
                child:  Center(child: Text(aridNo,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),)),
              ),
              Center(child: Text("Application Status",style: TextStyle(fontSize: CustomSize().customHeight(context)/30,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
              Padding(
                padding: EdgeInsets.only(left:CustomSize().customWidth(context)/4),
                child: Center(child: Text(status,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
