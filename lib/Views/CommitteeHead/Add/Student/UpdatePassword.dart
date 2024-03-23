import 'package:financial_aid/Components/CustomButton.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:flutter/material.dart';

import '../../../../Resources/CustomSize.dart';

class UpdatePassword extends StatelessWidget {
  String name;
  String aridNo;
  int id;
  UpdatePassword(
      {super.key, required this.aridNo, required this.name, required this.id});

  FocusNode nameNode = FocusNode();

  FocusNode aridNoNode = FocusNode();

  FocusNode passwordNode = FocusNode();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _aridNoController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _aridNoController.text = aridNo;
    _nameController.text = name;
    return Scaffold(
      appBar: AppBar(
          title: const Text("Update Password"),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            readOnly: true,
            controller: _nameController,
            onFieldSubmitted: (e) {
              FocusScope.of(context).requestFocus(aridNoNode);
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
            readOnly: true,
            controller: _aridNoController,
            onFieldSubmitted: (e) {
              FocusScope.of(context).requestFocus(passwordNode);
            },
            decoration: InputDecoration(
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
            controller: _passwordController,
            onFieldSubmitted: (e) {
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Password",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      CustomSize().customWidth(context) / 40)),
            ),
          ),
          SizedBox(
            height: CustomSize().customWidth(context) / 5,
          ),
          CustomButton(
            title: "Update",
            loading: false,
            onTap: () async {
              int code = await AdminApiHandler().updatePassword(
                  id, _aridNoController.text, _passwordController.text);
              if (context.mounted) {
                if (code == 200) {
                  Navigator.pop(context);
                  Utilis.flushBarMessage("Updated", context);
                  _passwordController.text='';
                  id=0;
                } else {
                  Utilis.flushBarMessage("try again late", context);
                }
              }
            },
          )
        ],
      ),
    );
  }
}
