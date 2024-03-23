


import 'package:financial_aid/Components/CustomButton.dart';
import 'package:financial_aid/Resources/AppUrl.dart';
import 'package:flutter/material.dart';

import '../Resources/CustomSize.dart';

class CommitteeInfo extends StatelessWidget {
  bool isTrue;
  String name;
  String image;
  final VoidCallback? onTap;
  CommitteeInfo({super.key , required this.name,required this.image,required this.isTrue ,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only( top: CustomSize().customHeight(context)/45,left:CustomSize().customHeight(context)/38),
      child: Center(
        child: Container(
            height: CustomSize().customHeight(context)/10,
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
            child:Center(
              child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: CustomSize().customHeight(context) / 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customHeight(context) / 30),
                      child:EndPoint.imageUrl+image!="http://192.168.100.11/FinancialAidAllocation/Content/profileImages/"?Image(
                        image: NetworkImage(EndPoint.imageUrl + image),
                        width: CustomSize().customHeight(context) / 12,//CustomSize().customHeight(context)/15
                        height: CustomSize().customHeight(context) / 12,
                        fit: BoxFit.fill,
                      ):const Icon(Icons.person),
                    ),
                  ),
                  title: Text(name,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),),
                  trailing: CustomButton(title: "Add",loading: isTrue ,onTap: onTap,),
              ),
            )
        ),
      ),
    );
  }
}
