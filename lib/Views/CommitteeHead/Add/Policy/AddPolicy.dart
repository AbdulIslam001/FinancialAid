

import 'package:financial_aid/Components/CustomButton.dart';
import 'package:financial_aid/Resources/CustomSize.dart';
import 'package:flutter/material.dart';

class AddPolice extends StatefulWidget {
  AddPolice({super.key});

  @override
  State<AddPolice> createState() => _AddPoliceState();
}

class _AddPoliceState extends State<AddPolice> {

  String hintStr="Min cgpa required";
  bool isTrue=false;

  List<String> policyFor=["NeedBase","MeritBase"];

  final TextEditingController _val1=TextEditingController();
  final TextEditingController _val2=TextEditingController();
  final TextEditingController _amount=TextEditingController();
  final TextEditingController _description=TextEditingController();

  String selectedVal="NeedBase";
  String gVal="CGPA";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title:const Text("Add Police"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Policy For :",style: TextStyle(fontSize: CustomSize().customWidth(context)/20)),
                SizedBox(
                  width: CustomSize().customWidth(context)/10,
                ),
                DropdownButton(
                  value: selectedVal,
                    items:policyFor.map((e){
                      return DropdownMenuItem(
                          value: e.toString(),
                          child: Text(e.toString()));
                    }).toList(),
                    onChanged: (val){
                    selectedVal=val.toString();
                    setState((){});
                })
              ],
            ),
            Visibility(
              visible: isTrue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Radio(value: "CGPA", groupValue: gVal, onChanged: (e){
                        gVal=e.toString();
                        hintStr="Min cgpa required";
                        isTrue=false;
                        setState(() {

                        });
                      }),
                      const Text("CGPA")
                    ],
                  ),
                  SizedBox(
                    width: CustomSize().customWidth(context)/10,
                  ),
                  Row(
                    children: [
                      Radio(value: "STRENGTH", groupValue: gVal, onChanged: (e){
                        gVal=e.toString();
                        hintStr="Min Strength";
                        isTrue=true;
                        setState(() {

                        });
                      }),
                      const Text("STRENGTH")
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:CustomSize().customWidth(context)/20,right: CustomSize().customWidth(context)/20,top: CustomSize().customWidth(context)/30),
              child: TextFormField(
                onChanged: (val){},
                controller: _val1,
                decoration: InputDecoration(
                  hintText: hintStr,
                  labelText: hintStr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/60),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isTrue,
              child: Padding(
                padding: EdgeInsets.only(left:CustomSize().customWidth(context)/20,right: CustomSize().customWidth(context)/20,top: CustomSize().customWidth(context)/30),
                child: TextFormField(
                  controller: _val2,
                  decoration: InputDecoration(
                    hintText: "Max Strength",
                    labelText: "Max Strength",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/60),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isTrue,
              child: Padding(
                padding: EdgeInsets.only(left:CustomSize().customWidth(context)/20,right: CustomSize().customWidth(context)/20,top: CustomSize().customWidth(context)/30),
                child: TextFormField(
                  onChanged: (val){},
                  controller: _amount,
                  decoration: InputDecoration(
                    hintText: "Amount",
                    labelText: "Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/60),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:CustomSize().customWidth(context)/20,right: CustomSize().customWidth(context)/20,top: CustomSize().customWidth(context)/30),
              child: TextFormField(
                onChanged: (val){},
                controller: _description,
                decoration: InputDecoration(
                  hintText: "Description",
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/60),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: CustomSize().customHeight(context)/10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(title: "cancel", loading: false),
                SizedBox(
                  width: CustomSize().customWidth(context)/15,
                ),
                CustomButton(title: "Add", loading: false),
              ],
            )
          ],
        ),
      ),
    );
  }
}
