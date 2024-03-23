

import 'dart:convert';

import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Faculty/FacultyRecord.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Student/StudentRecord.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/DrawerCustomButtons.dart';
import '../../Components/OptionContainer.dart';
import '../../Models/FacultyModel.dart';
import '../../Models/Student.dart';
import '../../Resources/AppUrl.dart';
import '../../Resources/CustomSize.dart';

class CommitteeHeadDashBoard extends StatefulWidget {
  const CommitteeHeadDashBoard({super.key});

  @override
  State<CommitteeHeadDashBoard> createState() => _CommitteeHeadDashBoardState();
}

class _CommitteeHeadDashBoardState extends State<CommitteeHeadDashBoard> {

  String name='';
  String profileImage='';
  bool isTrue=false;
  Future<void> getAdminData()async{
    Response res =await AdminApiHandler().getAdminInfo();
    if(res.statusCode==200){
      dynamic obj=jsonDecode(res.body);
      name=obj['Name'].toString();
      profileImage=obj['ProfilePic'].toString();
      if(profileImage!=null || profileImage!=''){
        isTrue=true;
      }
    }else if(context.mounted){
      Utilis.flushBarMessage("try again later", context);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    getAdminData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("CommitteeHead"),
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
        width: CustomSize().customWidth(context)/1.8,
        child: ListTile(
          title: Padding(
            padding: EdgeInsets.only(top:CustomSize().customWidth(context)/10),
            child: GestureDetector(
              onTap: (){},
              child: FutureBuilder(
                future: getAdminData(),
                builder: (context, snapshot) {
                return CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: CustomSize().customHeight(context) / 13,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        CustomSize().customHeight(context) / 13),
                    child:EndPoint.imageUrl+profileImage=="http://192.168.100.11/FinancialAidAllocation/Content/profileImages/"?
                    Icon(Icons.person,size: CustomSize().customHeight(context)/10):Image(
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
          subtitle:Column(
            children: [
              FutureBuilder(
                future: getAdminData(),
                builder: (context, snapshot) {
                return Text(name,style: TextStyle(fontSize: CustomSize().customWidth(context)/15));
              },),
              Padding(
                padding: EdgeInsets.only(top:CustomSize().customWidth(context)/20),
                child:DrawerCustomButtons(title: "Budget",onTab: (){
                  Navigator.pushNamed(context, RouteName.budget);
                }) ,
              ),
              Padding(
                padding: EdgeInsets.only(top:CustomSize().customWidth(context)/20),
                child:DrawerCustomButtons(title: "Student",onTab: ()async{
//                  Navigator.pushNamed(context, RouteName.studentRecord);
                  Response res=await AdminApiHandler().getAllStudent();
                  List<Student> studentList=[];
                  if(res.statusCode==200 && context.mounted)
                  {
                    dynamic obj=jsonDecode(res.body);
                    for(var i in obj){
                      Student s = Student(
                        aridNo: i["arid_no"].toString(),
                        name: i["name"].toString(),
                        semester: int.parse(i["semester"].toString()),
                        cgpa: double.parse(i["cgpa"].toString()),
                        section: i["section"].toString(),
                        degree: i["degree"].toString(),
                        fatherName: i["father_name"].toString(),
                        gender: i["gender"].toString(),
                        studentId: int.parse(i["student_id"].toString()),
                        profileImage: i["profile_image"].toString(),
                      );
                      studentList.add(s);
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return StudentRecord(studentList: studentList,);
                    },));
                  }
                }) ,
              ),
              Padding(
                padding: EdgeInsets.only(top:CustomSize().customWidth(context)/20),
                child:DrawerCustomButtons(title: "Policies",onTab: (){}) ,
              ),
              Padding(
                padding: EdgeInsets.only(top:CustomSize().customWidth(context)/20),
                child:DrawerCustomButtons(title: "Faculty",onTab: ()async{
                   Navigator.pushNamed(context, RouteName.facultyRecord);
                }) ,
              ),
              Padding(
                padding: EdgeInsets.only(top:CustomSize().customWidth(context)/20),
                child:DrawerCustomButtons(title: "Committee",onTab: (){
                  Navigator.pushNamed(context, RouteName.committeeRecord);
                }) ,
              ),
              SizedBox(
                height: CustomSize().customHeight(context)/5,
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: CustomSize().customHeight(context)/100,
                ),
                OptionContainer(onTap: (){},image: "Assets/mbl.png",title: "Meritbase Shotlisting"),
                OptionContainer(onTap: (){}, image: "Assets/c1.png",title: "NeedBase Applications"),
              ],
            ),
            SizedBox(
              height: CustomSize().customHeight(context)/100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OptionContainer(onTap: (){},image: "Assets/ap.png",title: "Accepted Applications"),
                OptionContainer(onTap: (){}, image: "Assets/ra.png",title: "Rejected Applications"),
              ],
            ),
            SizedBox(
              height: CustomSize().customHeight(context)/100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OptionContainer(onTap: (){
                  Navigator.pushNamed(context, RouteName.committeeRecord);

                },image: "Assets/audience.png",title: "Committee Members"),
                OptionContainer(onTap: (){}, image: "Assets/user-graduate.png",title: "Assign graders"),
              ],
            ),
            SizedBox(
              height: CustomSize().customHeight(context)/100,
            ),
          ],
        ),
      ),
    );
  }
}


