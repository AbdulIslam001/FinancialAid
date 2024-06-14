

import 'dart:convert';

import 'package:financial_aid/Services/LoginApiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/CustomButton.dart';
import '../Resources/CustomColor.dart';
import '../Resources/CustomSize.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../viewModel/LoginViewModel.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController _userName = TextEditingController();

  final TextEditingController _password = TextEditingController();

  FocusNode username = FocusNode();

  FocusNode password = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: CustomColor().customGreyColor(),
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: CustomSize().customHeight(context) / 100,
              ),
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    height: CustomSize().customHeight(context) / 1.8,
                    width: CustomSize().customWidth(context) / 1.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customHeight(context) / 70),
                      color: CustomColor().customWhiteColor(),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                          CustomSize().customHeight(context) / 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            focusNode: username,
                            onFieldSubmitted: (e) {
                              FocusScope.of(context).requestFocus(password);
                            },
                            validator: (val){
                              if(_userName.text.isEmpty){
                                return "Enter UserName";
                              }
                            },
                            controller: _userName,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              icon: Icon(Icons.person),
                              labelText: 'UserName',
                              hintText: 'UserName',
                            ),
                          ),
                          SizedBox(
                            height: CustomSize().customHeight(context) / 100,
                          ),
                          Consumer<LoginViewModel>(
                            builder: (context, value, child) {
                              return TextFormField(
                                validator: (val){
                                  if(_password.text.isEmpty){
                                    return "Enter UserName";
                                  }
                                },
                                controller: _password,
                                focusNode: password,
                                onFieldSubmitted: (e) {
                                  FocusScope.of(context).unfocus();
                                },
                                obscureText: value.isObscure,
                                decoration: InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    labelText: 'Password',
                                    hintText: 'Password',
                                    icon: const Icon(Icons.password),
                                    suffixIcon: GestureDetector(
                                        onTap: (){
                                          value.setIsObscure(!value.isObscure);
                                         },
                                        child: value.isObscure
                                            ? const Icon(Icons.visibility_off)
                                            : const Icon(Icons.visibility))),
                              );
                            },
                          ),
                          SizedBox(
                            height: CustomSize().customHeight(context) / 100,
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                                CustomSize().customHeight(context) / 100),
                            child: Consumer<LoginViewModel>(
                              builder: (BuildContext context,
                                  LoginViewModel value, Widget? child) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomButton(
                                      title: 'Login',
                                      loading: value.loading,
                                      onTap: () async{
                                        if(!value.loading){
                                          if(_formKey.currentState!.validate()){
                                            value.setLoading(true);
                                            Response res=await LoginApiHandler().login(_userName.text.toString(), _password.text.toString());
                                            if(res.statusCode==200 && context.mounted)
                                            {
                                              dynamic obj=jsonDecode(res.body);
                                              if(int.parse(obj["role"].toString())==1)
                                              {
                                                Navigator.pushReplacementNamed(context, RouteName.committeeHeadDashBoard);
                                              }else if(int.parse(obj["role"].toString())==2)
                                              {
                                                Navigator.pushReplacementNamed(context, RouteName.committeeDashBoard);
                                              }else if(int.parse(obj["role"].toString())==3)
                                              {
                                                Navigator.pushReplacementNamed(context, RouteName.facultyDashBoard);
                                              }else
                                              {
                                                Navigator.pushReplacementNamed(context, RouteName.studentDashBoard);
                                              }
                                              SharedPreferences sp=await SharedPreferences.getInstance();
                                              sp.setBool("inLogin", true);
                                              sp.setInt("id", int.parse(obj["profileId"].toString()));
                                              sp.setInt("role", int.parse(obj["role"].toString()));
                                            }else if(res.statusCode==204 && context.mounted)
                                            {
                                              Utilis.flushBarMessage("Account not Exist", context);
                                            }else if(context.mounted){
                                              Utilis.flushBarMessage("Try again later", context);
                                            }
                                          }
                                          value.setLoading(false);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
