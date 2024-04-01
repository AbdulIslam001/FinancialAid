

import 'package:financial_aid/Resources/CustomSize.dart';
import 'package:flutter/material.dart';

class NeedBaseApplication extends StatelessWidget {
  const NeedBaseApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: CustomSize().customHeight(context)/13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: CustomSize().customWidth(context)/2.5,
                  height:CustomSize().customHeight(context)/12,
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
                  child:const Center(child: Text("View Application")),
                ),
              ],
            ),
            SizedBox(
              height: CustomSize().customHeight(context)/100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Father status",
                  style: TextStyle(
                      fontSize: CustomSize().customHeight(context) / 40,
                      fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  width: CustomSize().customWidth(context)/10,
                ),
                Text(
                  "Alive",
                  style: TextStyle(
                      fontSize: CustomSize().customHeight(context) / 40,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
