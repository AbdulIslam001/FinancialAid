

import 'package:financial_aid/Resources/CustomSize.dart';
import 'package:flutter/material.dart';

class AddPolice extends StatefulWidget {
  AddPolice({super.key});

  @override
  State<AddPolice> createState() => _AddPoliceState();
}

class _AddPoliceState extends State<AddPolice> {
  List<String> policyFor=["NeedBase","MeritBase"];

  final TextEditingController _val1=TextEditingController();
  final TextEditingController _val2=TextEditingController();

  String selectedVal="NeedBase";
  String gVal="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title:const Text("Add Police"),
      ),
      body: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Radio(value: "CGPA", groupValue: gVal, onChanged: (e){
                    gVal=e.toString();
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
                    setState(() {

                    });
                  }),
                  const Text("STRENGTH")
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left:CustomSize().customWidth(context)/20,right: CustomSize().customWidth(context)/20,top: CustomSize().customWidth(context)/30),
            child: TextFormField(
              onChanged: (val){},
              controller: _val1,
              decoration: InputDecoration(
                hintText: "minimum cgpa",
                labelText: "minimum cgpa",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/60),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:CustomSize().customWidth(context)/20,right: CustomSize().customWidth(context)/20,top: CustomSize().customWidth(context)/30),
            child: TextFormField(
              onChanged: (val){},
              controller: _val2,
              decoration: InputDecoration(
                hintText: "search",
                labelText: "search",
                suffixIcon:Icon(Icons.search,size: CustomSize().customWidth(context)/10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/60),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
