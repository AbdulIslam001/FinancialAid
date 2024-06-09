
import 'package:financial_aid/viewModel/StudentViewModel/StudentInfoViewModel.dart';
import 'package:flutter/material.dart';

import '../Resources/CustomSize.dart';

class InfoContainer extends StatelessWidget {
  String name;
  String aridNo;
  String status;
  String session;
  String amount;
  InfoContainer({super.key,required this.amount,required this.name,required this.session,required this.aridNo,required this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only( top: CustomSize().customHeight(context)/45),
      child: Center(
        child: Container(
          height: CustomSize().customHeight(context)/3.5,
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
              Center(child:
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Welcome",style: TextStyle(fontSize: CustomSize().customHeight(context)/30,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                    Container(
                      height: CustomSize().customHeight(context)/25,
                      width: CustomSize().customWidth(context)/3,
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
                      child:Center(child: Text(session,style: TextStyle(fontSize: CustomSize().customHeight(context)/70,fontStyle: FontStyle.italic),)),
                    ),

                  ],
                ),
                subtitle: Column(
                  children: [
                    Text(name,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),),
                    Text(aridNo,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),),
                  ],
                ),
              )),
              /*Padding(
                padding: EdgeInsets.only(left:CustomSize().customWidth(context)/4),
                child:  Center(child: Text(aridNo,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),)),
              ),*/
              ListTile(
                title:Text("Application Status",style: TextStyle(fontSize: CustomSize().customHeight(context)/50,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),) ,
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(status,style: TextStyle(fontSize: CustomSize().customHeight(context)/50,fontStyle: FontStyle.italic),),
                    status=="Accepted"?Row(
                      children: [
                        Text("Approved Amount : ",style: TextStyle(fontSize: CustomSize().customHeight(context)/50,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                        Text(amount,style: TextStyle(fontSize: CustomSize().customHeight(context)/50,fontStyle: FontStyle.italic),),
                      ],
                    ):
                    SizedBox(),
                  ],
                ),
              ),
/*              Center(child: Text("Application Status",style: TextStyle(fontSize: CustomSize().customHeight(context)/30,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
              Padding(
                padding: EdgeInsets.only(left:CustomSize().customWidth(context)/4),
                child: Center(child: Text(status,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),)),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
