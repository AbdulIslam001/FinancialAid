import 'dart:io';

import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Components/CustomButton.dart';
import '../../../../Resources/CustomSize.dart';

class AddFacultyMember extends StatefulWidget {
  const AddFacultyMember({super.key});

  @override
  State<AddFacultyMember> createState() => _AddFacultyMemberState();
}

class _AddFacultyMemberState extends State<AddFacultyMember> {
  final TextEditingController _name = TextEditingController();

  final TextEditingController _contactNo = TextEditingController();

  final TextEditingController _password = TextEditingController();

  FocusNode name = FocusNode();

  FocusNode contact = FocusNode();

  File? pickedImage;

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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Add Faculty Member"),
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
                  radius: CustomSize().customHeight(context) / 20,
                  child: pickedImage != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(
                        CustomSize().customHeight(context) / 30),
                          child: Image(
                              image: FileImage(pickedImage!.absolute),
                              filterQuality: FilterQuality.high,
                              width: CustomSize().customHeight(context) / 10,//CustomSize().customHeight(context)/15
                              height: CustomSize().customHeight(context) / 10,
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
                  FocusScope.of(context).requestFocus(contact);
                },
                decoration: InputDecoration(
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
                controller: _contactNo,
                onFieldSubmitted: (e) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  labelText: "contact No.",
                  hintText: "contact No.",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customWidth(context) / 20)),
                ),
              ),
              SizedBox(
                height: CustomSize().customWidth(context) / 60,
              ),
              TextFormField(
                controller: _password,
                onFieldSubmitted: (e) {
                  FocusScope.of(context).unfocus();
                },
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
                  int code = await AdminApiHandler().addFacultyMember(
                      _name.text,
                      _contactNo.text,
                      _password.text,
                      pickedImage!.absolute);
                  if(context.mounted){
                    if(code==200){
                      Navigator.pushReplacementNamed(context, RouteName.facultyRecord);
                    }else{
                      Utilis.flushBarMessage("error try again", context);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
