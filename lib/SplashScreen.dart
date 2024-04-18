

import 'package:financial_aid/Resources/CustomSize.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utilis/Routes/RouteName.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  isLogin()async{
    SharedPreferences sp= await SharedPreferences.getInstance();
    bool isLogin=false;
    sp.getBool('inLogin').toString()=="null"?isLogin=false:isLogin=true;
    await Future.delayed(const Duration(seconds: 1));
    if(isLogin && context.mounted){
      int role=int.parse(sp.getInt('role').toString());
      if(role==1){
        Navigator.pushReplacementNamed(context, RouteName.committeeHeadDashBoard);
      }else if(role==2){
        Navigator.pushReplacementNamed(context, RouteName.committeeDashBoard);
      }else if(role==3){
        Navigator.pushReplacementNamed(context, RouteName.facultyDashBoard);
      }else if(role==4){
        Navigator.pushReplacementNamed(context, RouteName.studentDashBoard);
      }else{
        Navigator.pushReplacementNamed(context, RouteName.login);
      }
    }else if(!isLogin&&context.mounted){
      Navigator.pushReplacementNamed(context, RouteName.login);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLogin();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: CustomSize().customHeight(context),
        width: CustomSize().customWidth(context),
        decoration:const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("Assets/splashImage.png"),
            fit: BoxFit.cover,
          )
        ),
      ),
    );
  }
}
