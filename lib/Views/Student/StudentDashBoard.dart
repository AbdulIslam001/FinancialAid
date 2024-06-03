import 'dart:convert';

import 'package:financial_aid/Components/InfoContainer.dart';
import 'package:financial_aid/Components/OptionContainer.dart';
import 'package:financial_aid/Resources/AppUrl.dart';
import 'package:financial_aid/Resources/CustomSize.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Services/Student/StudentApiHandler.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Policy/Policy.dart';
import 'package:financial_aid/Views/Student/Application/ApplicationForm.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/DrawerCustomButtons.dart';
import '../../Utilis/FlushBar.dart';
import '../../viewModel/StudentViewModel/StudentInfoViewModel.dart';

class StudentDashBoard extends StatefulWidget {
  const StudentDashBoard({super.key});

  @override
  State<StudentDashBoard> createState() => _StudentDashBoardState();
}

String name = '';
String aridNo = '';
int semester = 1;
String fatherName = '';
String cgpa = '';
String applicationStatus = "";
String profileImage = "";

class _StudentDashBoardState extends State<StudentDashBoard> {


  String session='';

  Future<void> getSession() async {
    Response res = await AdminApiHandler().getSession();
    if (res.statusCode == 200) {
      dynamic obj = jsonDecode(res.body);
      session = obj['session1'].toString();
    }
  }

  Future<void> getStudentData() async {
    Response res = await StudentApiHandle().getStudentInfo();
    dynamic obj = jsonDecode(res.body);
    name = obj["name"].toString();
    aridNo = obj["arid_no"].toString();
    fatherName = obj["father_name"].toString();
    semester = int.parse(obj["semester"].toString());
    cgpa = obj['cgpa'].toString();
    profileImage = obj["profile_image"].toString();
    StudentInfoViewModel()
        .setStudentInfo(obj["name"].toString(), obj["arid_no"].toString());
  }

  Future<void> getApplicationStatus() async {
    Response res = await StudentApiHandle().applicationStatus();
    if (res.statusCode == 200) {
      dynamic obj = jsonDecode(res.body);
      if (obj != null) {
        obj["applicationStatus"].toString() != null
            ? applicationStatus = obj["applicationStatus"].toString()
            : applicationStatus = 'Not Submitted';
      } else {
        applicationStatus = 'Not Submitted';
      }
    }else if(res.statusCode==404){
      applicationStatus = 'Not Submitted';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudentData();
    getApplicationStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Biit"),
        centerTitle: true,
        actions: [
          Padding(
            padding:
                EdgeInsets.only(right: CustomSize().customHeight(context) / 45),
            child: const Image(image: AssetImage("Assets/aridlogo.png")),
          )
        ],
      ),
      drawer: Drawer(
        width: CustomSize().customWidth(context) / 1.7,
        child: ListTile(
          title: Padding(
            padding:
                EdgeInsets.only(top: CustomSize().customWidth(context) / 10),
            child: GestureDetector(
              onTap: () {},
              child: FutureBuilder(
                future: getStudentData(),
                builder: (context, snapshot) {
                  return CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: CustomSize().customHeight(context) / 13,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customHeight(context) / 13),
                      child: EndPoint.imageUrl + profileImage ==
                                  EndPoint.imageUrl + "null" ||
                              EndPoint.imageUrl + profileImage ==
                                  EndPoint.imageUrl
                          ? Icon(
                              Icons.person,
                              size: CustomSize().customHeight(context) / 10,
                            )
                          : Image(
                              image: NetworkImage(
                                  EndPoint.imageUrl + profileImage),
                              width: CustomSize().customHeight(context) / 6,
                              height: CustomSize().customHeight(context) / 6,
                              fit: BoxFit.fill,
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
          subtitle: Column(
            children: [
              SizedBox(
                height: CustomSize().customHeight(context) / 1.4,
              ),
              DrawerCustomButtons(
                  title: "Logout",
                  onTab: () async {
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    sp.clear();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, RouteName.login);
                    }
                  }),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
           /* FutureBuilder(future: getSession(), builder: (context, snapshot) {
              return Padding(
                padding: EdgeInsets.only(left:CustomSize().customWidth(context)/100),
                child: Center(child: Text(session,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic,),)),
              );
            },),*/
            FutureBuilder(future: getApplicationStatus(),
              builder: (context, snapshot) {
              return FutureBuilder(
                future: getSession(),
                builder: (context, snapshot) {
                  return   FutureBuilder(
                    future: getStudentData(),
                    builder: (context, snapshot) {
                      return Consumer<StudentInfoViewModel>(
                        builder: (context, value, child) {
                          return InfoContainer(
                              session: session,
                              name: name, aridNo: aridNo, status: applicationStatus);
                        },
                      );
                    },
                  );
                },);
            },),
            SizedBox(
              height: CustomSize().customHeight(context) / 100,
            ),
            Consumer<StudentInfoViewModel>(
              builder: (context, value, child) {
              return Visibility(
                visible: applicationStatus == 'Not Submitted' ? false : true,
                child: const Text("Apply before 01/03/2024"),
              );
            },),
            SizedBox(
              height: CustomSize().customHeight(context) / 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OptionContainer(
                    onTap: () async{
                      if (applicationStatus == 'Pending') {
                        Utilis.flushBarMessage(
                            "Application already submitted", context);
                      } else {
                        Response res=await StudentApiHandle().checkCgpaPolicy();
                        if(context.mounted){
                          if(res.statusCode==200){
                            dynamic obj=jsonDecode(res.body);
                            if(obj ==null){
                              Utilis.flushBarMessage("No Policy Exist", context);
                            }else{
                              if(double.parse(cgpa)>=double.parse(obj['val1'].toString())){
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return ApplicationForm(
                                      aridNo: aridNo,
                                      cgpa: cgpa,
                                      name: name,
                                      fatherName: fatherName,
                                      semester: semester);
                                },));
                              }else{
                                Utilis.flushBarMessage("Your cgpa does not match the criteria", context);
                              }
                            }
                          }else{
                            Utilis.flushBarMessage("error try again later", context);
                          }
                        }
                      }
                    },
                    image: "Assets/scholarship.png",
                    title: "Apply for Scholarship"),
                OptionContainer(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) {
                        return Policy(show: false,isAdd: false,type: 'NeedBase',);
                      },));
                    },
                    image: "Assets/c1.png",
                    title: "NeedBase criteria"),
              ],
            ),
            SizedBox(
              height: CustomSize().customHeight(context) / 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OptionContainer(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) {
                        return Policy(show: false,isAdd: false,type: 'MeritBase',);
                      },));
                    },
                    image: "Assets/c1.png",
                    title: "MeritBase criteria"),
                OptionContainer(
                    onTap: () {}, image: "Assets/Help.png", title: "Need Help"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
