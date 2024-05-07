





import 'package:financial_aid/viewModel/StudentViewModel/StudentInfoViewModel.dart';
import 'package:flutter/material.dart';

import '../Resources/CustomSize.dart';

class PolicyInfoContainer extends StatelessWidget {
  String description;
  String session;
  String policyFor;
  String policy;
  String cgpa;
  PolicyInfoContainer({super.key,required this.cgpa,required this.policy ,required this.description,required this.session,required this.policyFor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only( top: CustomSize().customHeight(context)/45),
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
                  Icon(Icons.edit)
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left:CustomSize().customWidth(context)/6,top:CustomSize().customWidth(context)/18 ),
                  child: Text("Require Cgpa : $cgpa",style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),),
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
            //  Text("Remaining Amount : $remainingAmount",style: TextStyle(fontSize: CustomSize().customHeight(context)/50,fontStyle: FontStyle.italic),),
          ],
        ),
      ),
    );
  }
}
