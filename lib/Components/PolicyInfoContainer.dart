





import 'package:financial_aid/viewModel/StudentViewModel/StudentInfoViewModel.dart';
import 'package:flutter/material.dart';

import '../Resources/CustomSize.dart';

class PolicyInfoContainer extends StatelessWidget {
  String description;
  String session;
  String policyFor;
  String policy;
  String val1;
  String val2;
  bool show;
  VoidCallback? onTap;
  PolicyInfoContainer({super.key,required this.show,required this.val1,required this.val2,required this.policy ,required this.description,required this.session,required this.policyFor,this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only( top: CustomSize().customHeight(context)/50,left: CustomSize().customHeight(context)/100,right: CustomSize().customHeight(context)/100),
      child: Container(
        height: CustomSize().customHeight(context)/5,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: CustomSize().customWidth(context)/15,right: CustomSize().customWidth(context)/15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                    child:Center(child: Text(policyFor,style: TextStyle(fontSize: CustomSize().customHeight(context)/70,fontStyle: FontStyle.italic),)),
                  ),
                  Visibility(
                      visible: show,
                      child: GestureDetector(
                          onTap: onTap,
                          child: const Icon(Icons.edit)))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left:CustomSize().customWidth(context)/15,top:CustomSize().customWidth(context)/18 ),
                  child: Text(policyFor=="NeedBase"?"Require Cgpa : $val1":
                  policyFor=="MeritBase"?policy=="CGPA"?"Require Cgpa : $val1":
                  "Min Strength : $val1":"",style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),),
                ),
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
            Padding(
              padding: EdgeInsets.only(top:CustomSize().customWidth(context)/150,left:CustomSize().customWidth(context)/40,right: CustomSize().customWidth(context)/40 ),
              child: Text(description,style: TextStyle(fontSize: CustomSize().customHeight(context)/50,fontStyle: FontStyle.italic),),
            ),
          ],
        ),
      ),
    );
  }
}
