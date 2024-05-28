
import 'dart:io';

import 'package:financial_aid/Components/CustomButton.dart';
import 'package:financial_aid/Resources/CustomSize.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:financial_aid/Views/Student/Application/ApplicationForm_one.dart';
import 'package:financial_aid/Views/Student/StudentDashBoard.dart';
import 'package:financial_aid/viewModel/StudentViewModel/FilePickerViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../Utilis/Routes/RouteName.dart';

class ApplicationForm extends StatefulWidget {

  String name;
  String aridNo;
  int semester;
  String cgpa;
  String fatherName;


  ApplicationForm({super.key,required this.cgpa, required this.aridNo,required this.name,required this.fatherName,required this.semester});

  @override
  State<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  final TextEditingController _name= TextEditingController();

  final TextEditingController _aridNo= TextEditingController();

  final TextEditingController _semester= TextEditingController();

  final TextEditingController _occupation= TextEditingController();

  final TextEditingController _contact= TextEditingController();

  final TextEditingController _salary= TextEditingController();

  final TextEditingController _cgpa=TextEditingController();

  final TextEditingController _gName=TextEditingController();

  final TextEditingController _relation=TextEditingController();

  final TextEditingController _fName=TextEditingController();

  final TextEditingController _gContact=TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool status=true;

  String gVal="Alive";


  @override
  Widget build(BuildContext context) {
    _name.text=name;
    _aridNo.text=aridNo;
    _semester.text=semester.toString();
    _fName.text=fatherName;
    _cgpa.text=cgpa;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
            title:const Text("Apply"),
            centerTitle: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(CustomSize().customWidth(context)/25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    readOnly: true,
                    controller: _name,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Name',
                      hintText: 'Name',
                    ),
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: _aridNo,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Arid no',
                      hintText: 'Arid no',
                    ),
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: _cgpa,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Cgpa',
                      hintText: 'cgpa',
                    ),
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: _semester,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Semester',
                      hintText: 'Semester',
                    ),
                  ),
                  Text("Father",style: TextStyle(fontSize: CustomSize().customHeight(context)/50)),
                  Row(
                    children: [
                      Expanded(child: RadioListTile(
                          selected: true,
                          value: "Alive",groupValue: gVal, onChanged: (val){
                        gVal=val.toString();
                        status=true;
                        setState(() {

                        });
                      },title:const Text("Alive"))),
                      Expanded(child: RadioListTile(value: "Deceased",groupValue: gVal, onChanged: (val){
                        gVal=val.toString();
                        status=false;
                        setState(() {

                        });
                      },title:const Text("Decease")))
                    ],
                  ),
                  status?Column(
                    children: [
                      Text("Parents Details:",style: TextStyle(fontSize: CustomSize().customHeight(context)/50),),
                      TextFormField(
                        readOnly: true,
                        controller: _fName,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Father Name',
                          hintText: 'Father Name',
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _occupation,
                        validator: (String? val){
                          if(val!.isEmpty){
                            return "enter father occupation";
                          }
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Occupation',
                          hintText: 'Occupation',
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (String? val){
                          if(val!.isEmpty){
                            return "enter contact number";
                          }else if(val!.length>11){
                            return "Invalid Number";
                          }else if(val!.length<11){
                            return "Invalid Number";
                          }
                        },
                        controller: _contact,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'contact no.',
                          hintText: 'contact no.',
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (String? val){
                          if(val!.isEmpty){
                            return "enter salary";
                          }
                        },
                        controller: _salary,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Salary',
                          hintText: 'Salary',
                        ),
                      ),
                      Consumer<FilePickerViewModel>(
                        builder: (context, value, child) {
                        return Row(
                          children: [
                            Text("Salary Slip",style: TextStyle(fontSize: CustomSize().customHeight(context)/50)),
                            TextButton(onPressed: (){
                              value.setDocs1();
                            }, child:const Text("Upload"),),
                            Center(
                              child: value.slipStatus?const Icon(Icons.check,color: Colors.blue,):const Text(""),
                            )
                          ],
                        );
                      },),
                    ],
                  ): Column(
                    children: [
                      Consumer<FilePickerViewModel>(builder: (context, value, child) {
                        return Row(
                            children: [
                              Text("Death Certificate",style: TextStyle(fontSize: CustomSize().customHeight(context)/50)),
                              TextButton(onPressed: (){
                                value.setDeathCertificate();
                              }, child:const Text("Upload"),),
                              Center(
                                child: value.certificateStatus?const Icon(Icons.check,color: Colors.blue,) :const Text(""),
                              )
                            ],
                          );

                      },),
                      Text("Guardian Details:",style: TextStyle(fontSize: CustomSize().customHeight(context)/40),),
                      TextFormField(
                        validator: (String? val){
                          if(val!.isEmpty){
                            return "enter guardian name";
                          }
                        },
                        controller: _gName,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Guardian Name',
                          hintText: 'Guardian Name',
                        ),
                      ),
                      TextFormField(
                        validator: (String? val){
                          if(val!.isEmpty){
                            return "enter guardian contact";
                          }
                        },
                        controller: _gContact,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Guardian contact',
                          hintText: 'Guardian contact',
                        ),
                      ),
                      TextFormField(
                        controller: _relation,
                        validator: (String? val){
                          if(val!.isEmpty){
                            return "enter relationship guardian";
                          }
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Guardian Relation',
                          hintText: 'Guardian Relation',
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: CustomSize().customHeight(context)/35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(title: "cancel", loading: false,onTap: (){
                          Navigator.pushReplacementNamed(context, RouteName.studentDashBoard);
                        },),
                        Consumer<FilePickerViewModel>(
                          builder: (context, value, child) {
                          return CustomButton(title: "Next", loading: false,onTap: (){
                            if(_formKey.currentState!.validate()){
                              if(gVal=='Deceased' && !value.certificateStatus){
                                Utilis.flushBarMessage("Death certificate is mandatory", context);
                              }else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return ApplicationFormOne(status:gVal,contactNo: _contact.text.toString(),
                                    fatherOccupation: _occupation.text,docs: value.pickedDocs,
                                    guardianContact: _gContact.text,guardianName: _gName.text,
                                    guardianRelation: _relation.text,salary: _salary.text,);
                                },));
                              }
                            }
                          },);
                          },),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
