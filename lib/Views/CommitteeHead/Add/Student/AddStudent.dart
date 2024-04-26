import 'dart:io';

import 'package:financial_aid/Components/CustomButton.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:financial_aid/viewModel/CommitteeHeadViewModel/DegreeSelectionViewModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../Resources/CustomSize.dart';

class AddStudent extends StatefulWidget {
  AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final TextEditingController _name = TextEditingController();

  final TextEditingController _semester = TextEditingController();

  final TextEditingController _cgpa = TextEditingController();

  final TextEditingController _aridNo = TextEditingController();

  final TextEditingController _section = TextEditingController();

  final TextEditingController _fatherName = TextEditingController();

  final TextEditingController _password = TextEditingController();

  String degreeSelected="BSCS";

  FocusNode name = FocusNode();
  FocusNode aridNo = FocusNode();

  FocusNode section = FocusNode();
  FocusNode fatherName = FocusNode();

  String gVal = "Male";
  String selectedVal="BSCS";
  File? pickedImage;
  List<String> degrees = ["BSCS", "BSIT", "BSAI", "BSSE"];

  final imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    Future<void> getImage() async {
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage = File(image.path);
        setState(() {});
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Student"),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(CustomSize().customWidth(context) / 30),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white38,
                    radius: CustomSize().customWidth(context) / 10,
                    child: pickedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customHeight(context) / 50),
                            child: Image(
                                image: FileImage(pickedImage!.absolute),
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.fill),
                          )
                        : const Icon(Icons.camera_alt),
                  ),
                ),
                SizedBox(
                  height: CustomSize().customWidth(context) / 20,
                ),
                TextFormField(
                  controller: _name,
                  onFieldSubmitted: (e) {
                    FocusScope.of(context).requestFocus(aridNo);
                  },
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search),
                    labelText: "Name",
                    hintText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            CustomSize().customWidth(context) / 40)),
                  ),
                ),
                SizedBox(
                  height: CustomSize().customWidth(context) / 60,
                ),
                TextFormField(
                  controller: _aridNo,
                  onFieldSubmitted: (e) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search),
                    labelText: "Arid No.",
                    hintText: "Arid No.",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            CustomSize().customWidth(context) / 20)),
                  ),
                ),
                SizedBox(
                  height: CustomSize().customWidth(context) / 60,
                ),
                TextFormField(
                  onFieldSubmitted: (e) {
                    FocusScope.of(context).requestFocus(fatherName);
                  },
                  controller: _semester,
                  decoration: InputDecoration(
                    labelText: "semester",
                    hintText: "semester",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            CustomSize().customWidth(context) / 20)),
                  ),
                ),
                SizedBox(
                  height: CustomSize().customWidth(context) / 60,
                ),
                Visibility(
                  visible: _semester.text == '1' ? false : true,
                  child: TextFormField(
                    onFieldSubmitted: (e) {
                      FocusScope.of(context).requestFocus(fatherName);
                    },
                    controller: _cgpa,
                    decoration: InputDecoration(
                      labelText: "cgpa",
                      hintText: "cgpa",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              CustomSize().customWidth(context) / 20)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: "M",
                        groupValue: gVal,
                        onChanged: (val) {
                          gVal = val.toString();
                          setState(() {});
                        }),
                    const Text("Male"),
                    SizedBox(
                      width: CustomSize().customWidth(context) / 8,
                    ),
                    Radio(
                        value: "F",
                        groupValue: gVal,
                        onChanged: (val) {
                          gVal = val.toString();
                          setState(() {});
                        }),
                    const Text("Female"),
                  ],
                ),
                TextFormField(
                  controller: _fatherName,
                  onFieldSubmitted: (e) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    labelText: "father name",
                    hintText: "father name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            CustomSize().customWidth(context) / 20)),
                  ),
                ),
                SizedBox(
                  height: CustomSize().customWidth(context) / 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Select Degree",
                      style: TextStyle(
                          fontSize: CustomSize().customWidth(context) / 22),
                    ),
                    Consumer<DegreeViewModel>(
                      builder: (context, value, child) {
                        return DropdownButton(
                          value: selectedVal,
                          hint: const Text("--Select--"),
                          onChanged: (e) {
                            selectedVal=e.toString();
                            setState(() {});
                          },
                          items: degrees.map((e) {
                            return DropdownMenuItem(
                              value: e.toString(),
                              child: Text(
                                e.toString(),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: CustomSize().customWidth(context) / 60,
                ),
                TextFormField(
                  onFieldSubmitted: (e) {
                    FocusScope.of(context).requestFocus(fatherName);
                  },
                  controller: _section,
                  decoration: InputDecoration(
                    labelText: "Section",
                    hintText: "Section",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            CustomSize().customWidth(context) / 20)),
                  ),
                ),
                SizedBox(
                  height: CustomSize().customWidth(context) / 60,
                ),
                TextFormField(
                  onFieldSubmitted: (e) {
                    FocusScope.of(context).requestFocus(fatherName);
                  },
                  controller: _password,
                  decoration: InputDecoration(
                    labelText: "password",
                    hintText: "password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            CustomSize().customWidth(context) / 20)),
                  ),
                ),
                SizedBox(
                  height: CustomSize().customWidth(context) / 5,
                ),
                CustomButton(
                  title: "Add",
                  loading: false,
                  onTap: () async {
                    int code = await AdminApiHandler().addStudent(
                        _name.text,
                        _password.text,
                        _aridNo.text,
                        _semester.text,
                        gVal,
                        _section.text,
                        pickedImage!.absolute,
                        _fatherName.text,
                        selectedVal,
                        _cgpa.text);
                    if (context.mounted) {
                      if (code == 200) {
                        Utilis.flushBarMessage("Add Successfully", context);
                        Navigator.pop(context);
                      } else {
                        Utilis.flushBarMessage("error!!", context);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
