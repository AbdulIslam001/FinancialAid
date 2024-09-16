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
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/DrawerCustomButtons.dart';
import '../../Models/ApplicationModel.dart';
import '../../Utilis/FlushBar.dart';
import '../../viewModel/CommitteeHeadViewModel/ApplicationHistory.dart';
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

  String amountApproved="";
  bool isTrue=false;

  Future<void> getApplicationStatus() async {
    Response res = await StudentApiHandle().applicationStatus();
    if (res.statusCode == 200) {
      dynamic obj = jsonDecode(res.body);
      if (obj != null) {
        amountApproved=obj["amount"].toString();
        obj["applicationStatus"].toString() != null
            ? applicationStatus = obj["applicationStatus"].toString()
            : applicationStatus = 'Not Submitted';
        if(obj["applicationStatus"].toString().toLowerCase()=="pending" && obj["aidtype"].toString().toLowerCase()=="meritbase"){
          isTrue=true;
        }
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
/*                  isTrue?showDialog(context: context, builder: (context) {
                    return const AlertDialog(
                      title: Text("isTrue"),
                    );
                  },):const Text("nothing");*/
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
              DrawerCustomButtons(
                  onTab: ()async{
                    SharedPreferences sp = await SharedPreferences.getInstance();
                List<Application> list=await ApplicationHistory().getAllApplication(sp.getInt('id')!.toInt());
                if(context.mounted){
                  if(list.isNotEmpty)
                  {
                    int totalAccepted=0;
                    int totalRejected=0;
                    for(var item in list){
                      if(item.session!=null && item.applicationStatus?.toLowerCase().toString()=='rejected'){
                        totalRejected++;
                      }else if(item.session!=null && item .applicationStatus?.toLowerCase().toString()=='accepted'){
                        totalAccepted++;
                      }
                    }
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: SizedBox(
                          height: CustomSize().customHeight(context)/2,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: CustomSize().customHeight(context)/100),
                                child: PieChart(
                                  legendOptions: const LegendOptions(
                                      legendPosition: LegendPosition.left),
                                  dataMap: {
                                    'Accepted':totalAccepted.toDouble(),
                                    'Rejected':totalRejected.toDouble(),
                                  },
                                  chartRadius: CustomSize().customWidth(context) / 3,
                                  chartValuesOptions: const ChartValuesOptions(
                                      showChartValuesInPercentage: true),
                                  centerText: "Accepted : $totalAccepted/Rejected : $totalRejected",
                                  animationDuration: const Duration(milliseconds: 1000),
                                  chartType: ChartType.ring,
                                  colorList: const [Colors.green, Colors.red],
                                ),
                              ),
                              Expanded(
                                child:  ListView.builder(
                                  itemCount: list.length,
                                  itemBuilder: (context, index1) {
                                    return Card(
                                      child: ListTile(
                                        title: Text(list[index1].name),
                                        subtitle: Text(list[index1].aridNo),
                                        trailing: Column(
                                          children: [
                                            Text(list[index1].session??""),
                                            Text(list[index1].applicationStatus??"",style:const TextStyle(color:Colors.red)),
                                          ],
                                        ),
                                      ),
                                    );
                                  },),
                              ),
                            ],
                          ),
                        ),
                      );
                    },);
                  }
                  else{
                    Utilis.flushBarMessage("No record Exist", context);
                  }
                }
              }, title: "History"),
              SizedBox(
                height: CustomSize().customHeight(context) / 1.6,
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
            FutureBuilder(
              future: getApplicationStatus(),
              builder: (context, snapshot) {
              return FutureBuilder(
                future: getSession(),
                builder: (context, snapshot) {
                  return   FutureBuilder(
                    future: getStudentData(),
                    builder: (context, snapshot) {
                      return Consumer<StudentInfoViewModel>(
                        builder: (context, value, child) {
                          return Column(
                            children: [
                              InfoContainer(
                                amount: amountApproved,
                                  session: session,
                                  name: name, aridNo: aridNo, status: applicationStatus),
                              isTrue?Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: ()async{
                                        int code=await StudentApiHandle().decideMeritBaseApplication("Rejected");
                                        if(context.mounted)
                                        {
                                          if(code==200){
                                            isTrue=false;
                                            setState(() {

                                            });
                                          }else if(code==404)
                                          {
                                            Utilis.flushBarMessage("Not Found", context);
                                          }else{
                                            Utilis.flushBarMessage("Error try again later", context);
                                          }
                                        }
                                      },
                                      child:const Text("Reject",style: TextStyle(color: Colors.red),)),
                                  SizedBox(
                                    width: CustomSize().customWidth(context)/30,
                                  ),
                                  GestureDetector(
                                      onTap: ()async{
                                        int code=await StudentApiHandle().decideMeritBaseApplication("Accepted");
                                        if(context.mounted)
                                        {
                                          if(code==200){
                                            isTrue=false;
                                            setState(() {

                                            });
                                          }else if(code==404)
                                          {
                                            Utilis.flushBarMessage("Not Found", context);
                                          }else{
                                            Utilis.flushBarMessage("Error try again later", context);
                                          }
                                        }
                                      },
                                      child:const Text("Accept",style: TextStyle(color: Colors.green),))
                                ],
                              ):Text(""),
                            ],
                          );
                        },
                      );
                    },
                  );
                },);
            },),
            SizedBox(
              height: CustomSize().customHeight(context) / 100,
            ),
/*            Consumer<StudentInfoViewModel>(
              builder: (context, value, child) {
              return Visibility(
                visible: applicationStatus == 'Not Submitted' ? true : false,
                child: const Text("Apply before 01/03/2024"),
              );
            },),*/
            SizedBox(
              height: CustomSize().customHeight(context) / 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OptionContainer(
                    onTap: () async{
                      if (applicationStatus == 'Not Submitted' ) {
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
                      }else
                      {
                        Utilis.flushBarMessage(
                            "Application already submitted", context);
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
