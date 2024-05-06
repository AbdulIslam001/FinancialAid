import 'dart:io';

import 'package:financial_aid/Models/ApplicationModel.dart';
import 'package:financial_aid/Services/Student/StudentApiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:financial_aid/viewModel/StudentViewModel/FilePickerViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Components/CustomButton.dart';
import '../../../Resources/CustomSize.dart';

class ApplicationFormOne extends StatefulWidget {
  String status;
  String? fatherOccupation;
  String? contactNo;
  String? salary;
  File? docs;
  String? guardianContact;
  String? guardianName;
  String? guardianRelation;

  ApplicationFormOne(
      {super.key,
      this.contactNo,
      this.salary,
      required this.status,
      this.docs,
      this.fatherOccupation,
      this.guardianContact,
      this.guardianName,
      this.guardianRelation});

  @override
  State<ApplicationFormOne> createState() => _ApplicationFormOneState();
}

TextEditingController _reason = TextEditingController();
TextEditingController _requiredAmount = TextEditingController();
final _formOneKey = GlobalKey<FormState>();
String gVal = "Own";
bool isOwn = true;

class _ApplicationFormOneState extends State<ApplicationFormOne> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Personal Details"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(CustomSize().customHeight(context) / 50),
            child: Form(
              key: _formOneKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "House",
                    style: TextStyle(
                        fontSize: CustomSize().customHeight(context) / 50),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: RadioListTile(
                              value: "Own",
                              groupValue: gVal,
                              onChanged: (val) {
                                isOwn = true;
                                gVal = val.toString();
                                setState(() {});
                              },
                              title: const Text("Own"))),
                      Expanded(
                          child: RadioListTile(
                              value: "Rent",
                              groupValue: gVal,
                              onChanged: (val) {
                                gVal = val.toString();
                                isOwn = false;
                                setState(() {});
                              },
                              title: const Text("Rent")))
                    ],
                  ),
                  Consumer<FilePickerViewModel>(
                    builder: (context, value, child) {
                      return Row(
                        children: [
                          isOwn
                              ? Text(
                                  "House Agreement",
                                  style: TextStyle(
                                      fontSize:
                                          CustomSize().customHeight(context) /
                                              50),
                                )
                              : const Text("Rental Agreement"),
                          TextButton(
                            onPressed: () {
                              value.setAgreement1();
                            },
                            child: const Text("Upload"),
                          ),
                          Center(
                            child: value.houseAgreementStatus
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.blue,
                                  )
                                : const Text(""),
                          )
                        ],
                      );
                    },
                  ),
                  TextFormField(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Reason is required";
                      }
                    },
                    controller: _reason,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Reason for scholarship',
                      hintText: 'Reason for scholarship',
                    ),
                  ),
                  /*Consumer<FilePickerViewModel>(
                    builder: (context, value, child) {
                      return Row(
                        children: [
                          Text(
                            "Evidence",
                            style: TextStyle(
                                fontSize:
                                    CustomSize().customHeight(context) / 50),
                          ),
                          TextButton(
                            onPressed: () {
                              value.pickedAgreement();
                            },
                            child: const Text("Upload"),
                          ),
                          Center(
                            child: value.evidenceStatus
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.blue,
                                  )
                                : const Text(""),
                          )
                        ],
                      );
                    },
                  ),*/
                  TextFormField(
                    controller: _requiredAmount,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Required Amount',
                      hintText: 'Required Amount',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: CustomSize().customHeight(context) / 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                          title: "cancel",
                          loading: false,
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, RouteName.studentDashBoard);
                          },
                        ),
                        Consumer<FilePickerViewModel>(
                          builder: (context, value, child) {
                            return CustomButton(
                              title: "Apply",
                              loading: value.loading,
                              onTap: () async{
                                value.setLoading(true);
                                if (_formOneKey.currentState!.validate() && context.mounted) {
                                  if (!value.houseAgreementStatus) {
                                    Utilis.flushBarMessage(
                                        "house agreement required", context);
                                  }else{
                                    SharedPreferences sp = await SharedPreferences.getInstance();
                                    int? id=sp.getInt('id');
                                    int code=await StudentApiHandle().sendApplication(
                                        value.length,
                                        value.slipStatus,widget.status,
                                          widget.fatherOccupation!, widget.contactNo!,
                                          widget.salary!, widget.docs?.absolute,
                                          widget.guardianName,
                                          widget.guardianContact, widget.guardianRelation, gVal.toString(),
                                          value.houseAgreement, _reason.text.toString(), _requiredAmount.text.toString(),
                                          id.toString());
                                      if(code==200 && context.mounted){
                                        Utilis.flushBarMessage("Application Submitted", context);
                                        Navigator.pushReplacementNamed(context, RouteName.studentDashBoard);
                                    }else if(code==401 && context.mounted){
                                        Utilis.flushBarMessage("Already submitted", context);
                                      }else if(context.mounted)
                                      {
                                        Utilis.flushBarMessage("error! try again later", context);
                                      }
                                  }
                                }
                                value.setLoading(false);
                              },
                            );
                          },
                        )
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
