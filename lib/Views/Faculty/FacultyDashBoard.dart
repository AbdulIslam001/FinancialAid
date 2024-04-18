import 'dart:convert';

import 'package:financial_aid/Services/Faculty/FacultyAPiHandler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/DrawerCustomButtons.dart';
import '../../Resources/AppUrl.dart';
import '../../Resources/CustomSize.dart';
import '../../Services/Committee/CommitteeApiHandler.dart';
import '../../Utilis/Routes/RouteName.dart';

class FacultyDashBoard extends StatelessWidget {
  FacultyDashBoard({super.key});
  String name="";
  String profileImage="";
  Future<void> getFacultyInfo()async{
    Response res= await FacultyApiHandler().getFacultyInfo();
    if(res.statusCode==200){
      dynamic obj=jsonDecode(res.body);
      name=obj["name"].toString();
      profileImage=obj["profilePic"].toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title:const Text("Faculty"),
      ),
      drawer:Drawer(
        width: CustomSize().customWidth(context) / 1.7,
        child: ListTile(
          title: Padding(
            padding:
            EdgeInsets.only(top: CustomSize().customWidth(context) / 10),
            child: GestureDetector(
              onTap: (){},
              child: FutureBuilder(
                future: getFacultyInfo(),builder: (context, snapshot) {
                return CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: CustomSize().customHeight(context) / 13,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        CustomSize().customHeight(context) / 13),
                    child:EndPoint.imageUrl+profileImage=="http://192.168.100.11/FinancialAidAllocation/Content/profileImages/null"||EndPoint.imageUrl+profileImage=="http://192.168.100.11/FinancialAidAllocation/Content/profileImages/"?
                    Icon(Icons.person,size: CustomSize().customHeight(context)/10,):Image(
                      image: NetworkImage(EndPoint.imageUrl + profileImage),
                      width: CustomSize().customHeight(context) / 6,
                      height: CustomSize().customHeight(context) / 6,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },),
            ),
          ),
          subtitle: Column(
            children: [
              FutureBuilder(
                future: getFacultyInfo(),
                builder: (context, snapshot) {
                  return Center(child:Text(name,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),));
                },),
              SizedBox(
                height: CustomSize().customHeight(context)/20,
              ),
              DrawerCustomButtons(title: "switch to faculty", onTab: ()async{
                Response res=await CommitteeApiHandler().switchRole();
                if(res.statusCode==200){
                  dynamic obj=jsonDecode(res.body);
                  SharedPreferences sp=await SharedPreferences.getInstance();
                  sp.setInt('id', int.parse(obj["profileId"].toString()));
                  sp.setInt("role", int.parse(obj["role"].toString()));
                  if(context.mounted){
                    Navigator.pushReplacementNamed(context, RouteName.splashScreen);
                  }
                }
              }),
              SizedBox(
                height: CustomSize().customHeight(context)/50,
              ),
              DrawerCustomButtons(title: "Balance", onTab: ()async{
                Response res=await CommitteeApiHandler().getBalance();
                if(res.statusCode==200 && context.mounted){
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Column(
                        children: [
                          Text("Remaining Balance",style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),),
                          Text(res.body,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),)
                        ],
                      ),);
                  },);
                }
              }),
              SizedBox(
                height: CustomSize().customHeight(context)/2.1,
              ),
              DrawerCustomButtons(title: "Logout", onTab: () async{
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.clear();
                if(context.mounted){
                  Navigator.pushReplacementNamed(context, RouteName.login);
                }
              }),
            ],
          ),
        ),
      ),
      body: Padding(
        padding:EdgeInsets.only(top: CustomSize().customWidth(context)/5,left: CustomSize().customWidth(context)/15,right: CustomSize().customWidth(context)/15),
        child: Container(
          width: CustomSize().customWidth(context)/1.2,
          height:CustomSize().customHeight(context)/1.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/80),
            color: Colors.blueGrey.withOpacity(0.2),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: CustomSize().customHeight(context)/1000,
                blurRadius: CustomSize().customHeight(context)/100,
                offset: Offset(CustomSize().customHeight(context)/1400,
                    CustomSize().customHeight(context)/1400),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: CustomSize().customHeight(context) / 13,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      CustomSize().customHeight(context) / 13),
                  child: Image(
                    image:const AssetImage("Assets/pro.jpeg"),
                    width: CustomSize().customHeight(context) / 6,
                    height: CustomSize().customHeight(context) / 6,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                    itemCount: 2,
                itemBuilder: (context, index) {
                      return const Card(
                        child: ListTile(
                    title: Text("Adnan"),
                    subtitle: Text("2020-arid-1213"),
                  ),
                );
              },))
            ],
          ),
        ),
      ),
    );
  }
}
