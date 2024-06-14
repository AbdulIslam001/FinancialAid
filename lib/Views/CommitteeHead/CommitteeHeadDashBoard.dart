import 'dart:convert';

import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Faculty/FacultyRecord.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Policy/Policy.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Session.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Student/StudentRecord.dart';
import 'package:financial_aid/Views/CommitteeHead/AllocationDetails.dart';
import 'package:financial_aid/Views/CommitteeHead/MeritBase/MeritBaseStudents.dart';
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
  String name = '';
  String profileImage = '';
  bool isTrue = false;

  String session='';

  Future<void> getSession() async {
    Response res = await AdminApiHandler().getSession();
    if (res.statusCode == 200) {
      dynamic obj = jsonDecode(res.body);
      session = obj['session1'].toString();
    }
  }

  Future<void> getAdminData() async {
    Response res = await AdminApiHandler().getAdminInfo();
    if (res.statusCode == 200) {
      dynamic obj = jsonDecode(res.body);
      name = obj['Name'].toString();
      profileImage = obj['profilepic'].toString();
      if (profileImage != null || profileImage != '') {
        isTrue = true;
      }
    }/* else if (context.mounted) {
      Utilis.flushBarMessage("try again later", context);
    }*/
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
      appBar: AppBar(
        title: const Text("CommitteeHead"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
        width: CustomSize().customWidth(context) / 1.8,
        child: ListTile(
          title: Padding(
            padding:
                EdgeInsets.only(top: CustomSize().customWidth(context) / 10),
            child: GestureDetector(
              onTap: () {},
              child: FutureBuilder(
                future: getAdminData(),
                builder: (context, snapshot) {
                  return CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: CustomSize().customHeight(context) / 13,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customHeight(context) / 13),
                      child: EndPoint.imageUrl + profileImage ==
                              EndPoint.imageUrl||EndPoint.imageUrl + profileImage ==
                          "${EndPoint.imageUrl}null"
                          ? Icon(Icons.person,
                              size: CustomSize().customHeight(context) / 10)
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
              FutureBuilder(
                future: getAdminData(),
                builder: (context, snapshot) {
                  return Text(name,
                      style: TextStyle(
                          fontSize: CustomSize().customWidth(context) / 15));
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: CustomSize().customWidth(context) / 20),
                child: DrawerCustomButtons(
                    title: "Budget",
                    onTab: () {
                      Navigator.pushNamed(context, RouteName.budget);
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: CustomSize().customWidth(context) / 20),
                child: DrawerCustomButtons(
                    title: "Student",
                    onTab: () async {
                  Navigator.pushNamed(context, RouteName.studentRecord);
 /*                     Response res = await AdminApiHandler().getAllStudent();
                      List<Student> studentList = [];
                      if (res.statusCode == 200 && context.mounted) {
                        dynamic obj = jsonDecode(res.body);
                        for (var i in obj) {
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
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return StudentRecord();
                          },
                        ));
                      }*/
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: CustomSize().customWidth(context) / 20),
                child: DrawerCustomButtons(title: "Policies", onTab: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Policy(show: true,isAdd: true,type: 'All',);

                  },));
                }),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: CustomSize().customWidth(context) / 20),
                child: DrawerCustomButtons(
                    title: "Faculty",
                    onTab: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return FacultyRecord(isShow: false);
                      },));
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: CustomSize().customWidth(context) / 20),
                child: DrawerCustomButtons(
                    title: "Session",
                    onTab: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return AddSession();
                      },));
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: CustomSize().customWidth(context) / 20),
                child: DrawerCustomButtons(
                    title: "Committee",
                    onTab: () {
                      Navigator.pushNamed(context, RouteName.committeeRecord);
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: CustomSize().customWidth(context) / 20),
                child: DrawerCustomButtons(
                    title: "Allocation\nSheet",
                    onTab: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return AllocationDetails(session: session);
                      },));
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: CustomSize().customWidth(context) / 20),
                child: DrawerCustomButtons(
                    title: "Logout",
                    onTab: () async {
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      if (context.mounted) {
                        sp.clear();
                        Navigator.pushReplacementNamed(context, RouteName.login);
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(future: getSession(), builder: (context, snapshot) {
              return Row(
                mainAxisAlignment:  MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left:CustomSize().customWidth(context)/100),
                    child: Container(
                      height: CustomSize().customHeight(context)/25,
                      width: CustomSize().customWidth(context)/3,
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
                      child:Center(child: Text(session,style: TextStyle(fontSize: CustomSize().customHeight(context)/70,fontStyle: FontStyle.italic),)),
                    ),
                  ),
                ],
              );
            },),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: CustomSize().customHeight(context) / 100,
                ),
                OptionContainer(
                    onTap: () async{
                      bool isTrue=false;
                      Response res=await AdminApiHandler().getMeritBaseShortListed();
                      if(context.mounted)
                      {
                        if(res.statusCode==200)
                        {
                          List<Student> list=[];
                          dynamic obj=jsonDecode(res.body);
                          for(var i in obj){
                            Student s= Student(aridNo: i['arid_no'].toString(),
                                name: i['name'].toString(),
                                semester: int.parse(i['semester'].toString()),
                                cgpa: double.parse(i['cgpa'].toString()),
                                section: i['section'].toString(),
                                degree: i['degree'].toString(),
                                fatherName: i['position'].toString(),
                                gender: i['gender'].toString(),
                                studentId: 0,//int.parse(i['student_id'].toString()),
                                profileImage: i['profile_image'].toString());
                            list.add(s);
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return MeritBaseStudent(isTrue: true);
                          },));
                        }else if(res.statusCode==400){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return MeritBaseStudent(isTrue: false);
                          },));
                        }else{
                          Utilis.flushBarMessage("error try again later", context);
                        }
                      }
                      //Navigator.pushNamed(context, RouteName.meritBase);
                    },
                    image: "Assets/mbl.png",
                    title: "Meritbase Shotlisting"),
                OptionContainer(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.needBaseScreen);
                    },
                    image: "Assets/c1.png",
                    title: "NeedBase Applications"),
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
                    onTap: () async{
                      Navigator.pushNamed(context, RouteName.acceptedApplication);
                    },
                    image: "Assets/ap.png",
                    title: "Accepted Applications"),
                OptionContainer(
                    onTap: () async {
                      Navigator.pushNamed(context, RouteName.rejectedApplication);
                    },
                    image: "Assets/ra.png",
                    title: "Rejected Applications"),
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
                      Navigator.pushNamed(context, RouteName.committeeRecord);
                    },
                    image: "Assets/audience.png",
                    title: "Committee Members"),
                OptionContainer(
                    image: "Assets/user-graduate.png",
                    title: "Assign graders",
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.graders);
                    }),
              ],
            ),
            SizedBox(
              height: CustomSize().customHeight(context) / 100,
            ),
          ],
        ),
      ),
    );
  }
}
