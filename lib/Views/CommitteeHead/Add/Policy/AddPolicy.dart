

import 'package:financial_aid/Components/CustomButton.dart';
import 'package:financial_aid/Models/PolicyModel.dart';
import 'package:financial_aid/Resources/CustomSize.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:flutter/material.dart';

class AddPolice extends StatefulWidget {
  AddPolice({super.key});

  @override
  State<AddPolice> createState() => _AddPoliceState();
}

class _AddPoliceState extends State<AddPolice> {

  String hintStr="Min cgpa required";
  bool isTrue=false;
  bool isRadio=false;

  List<String> policyFor=["NeedBase","MeritBase"];

  List<String> strength=["1","2","3"];
  String strengthVal="1";

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
        title:const Text("Add Policy"),
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
                    if(val=="MeritBase"){
                      isRadio=true;
                    }else if(val=="NeedBase"){
                      isRadio=false;
                    }
                    setState((){});
                })
              ],
            ),
            Visibility(
              visible: isRadio,
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
                child: Row(
                  children: [
                    const Text("Top :"),
                    DropdownButton(
                      value: strengthVal,
                        hint:const Text("Select"),
                        items: strength.map((e) {
                      return DropdownMenuItem(
                          value: e.toString(),
                          child: Text(e.toString()));
                    }).toList(),
                        onChanged: (val){
                        strengthVal=val.toString();
                          setState((){});
                    }),
                    const Text("Student will get"),

                  ],
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
                CustomButton(title: "Add", loading: false,onTap: ()async{
                  // PolicyModel pm = PolicyModel(description: _description.text,policyFor: selectedVal, strength: int.parse(strengthVal),
                  //     policy: gVal, val1: _val1.text, val2: _val2.text);
                  int code=await AdminApiHandler().addPolicy(_description.text, _val1.text, _val2.text, selectedVal, gVal, strengthVal);
                  if(context.mounted){
                    if(code==200){
                      Utilis.flushBarMessage("Added", context);
                      Navigator.pushReplacementNamed(context,RouteName.policy);
                    }
                    else{
                      Utilis.flushBarMessage("Error", context);
                    }
                  }
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
