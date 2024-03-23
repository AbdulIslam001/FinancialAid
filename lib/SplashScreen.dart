

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
    bool isLogin=bool.parse(sp.getBool('inLogin').toString());
    await Future.delayed(const Duration(seconds: 3));
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
      }
    }else if(context.mounted){
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
    return const Scaffold(
      body: Center(
        child: Text("Splash Screen"),
      ),
    );
  }
}
