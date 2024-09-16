import 'dart:convert';

import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:financial_aid/Views/CommitteeHead/NeedBase/NeedBaseApplicationDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../Models/ApplicationModel.dart';
import '../../../Models/EvidenceDocument.dart';
import '../../../Resources/AppUrl.dart';
import '../../../Resources/CustomSize.dart';
import '../../../Services/Committee/CommitteeApiHandler.dart';
import '../../Models/Student.dart';

class RejectApplication extends StatefulWidget {
  RejectApplication({super.key});

  @override
  State<RejectApplication> createState() => _RejectApplicationState();
}

class _RejectApplicationState extends State<RejectApplication> {
  final TextEditingController _search = TextEditingController();

  Future<List<Application>> getAllApplication()async{
    List<Application> applicationList=[];
    Response res=await AdminApiHandler().rejectedApplication();
    if(res.statusCode==200){
      dynamic response=jsonDecode(res.body);
      for(var obj in response){
        String ss='';
        String dc='';
        List<String> hg=[];
        for(int i =0 ; i<obj["EvidenceDocuments"].length;i++){
          if(obj["EvidenceDocuments"][i]["document_type"] !=null && obj["EvidenceDocuments"][i]["image"] !=null){
            if(obj["EvidenceDocuments"][i]["document_type"]=="salaryslip"){
              ss=obj["EvidenceDocuments"][i]["image"];
            }else if(obj["EvidenceDocuments"][i]["document_type"]=="deathcertificate"){
              dc=obj["EvidenceDocuments"][i]["image"];
            }else if(obj["EvidenceDocuments"][i]["document_type"]=="houseAgreement"){
              hg.add(obj["EvidenceDocuments"][i]["image"]);
            }
          }
        }
        List<String>? isApplication=[];
        List<String>? committeeMemberName=[];
        List<String> suggestionList=[];
        List<String> suggestedAmount=[];
        for(int j=0;j<obj["Suggestions"].length;j++){
          suggestionList.add(obj["Suggestions"][j]["comment"].toString());
          committeeMemberName.add(obj["Suggestions"][j]["CommitteeMemberName"].toString());
          isApplication.add(obj["Suggestions"][j]["status"].toString());
          suggestedAmount.add(obj["Suggestions"][j]["amount"].toString());
        }
        Application a = Application(
          isApplication: isApplication,
//          applicationStatus: obj['applicationStatus'].toString(),
          profileImage: obj["profile_image"].toString(),
          name: obj["name"].toString(),
          status: obj["father_status"].toString(),
          semester: obj["semester"].toString(),
          degree: obj["degree"].toString(),
          fatherName: obj["father_name"].toString(),
          section: obj["section"].toString(),
          amount: obj["requiredAmount"].toString(),
          gender: obj["gender"].toString(),
          aridNo: obj["arid_no"].toString(),
          cgpa: obj["cgpa"].toString(),
          studentId: obj["student_id"].toString(),
          reason: obj["reason"].toString(),
          applicationID: obj["applicationID"].toString(),
          deathCertificate: dc,
          agreement: hg,
          salarySlip: ss,
          house: obj["house"].toString(),
          occupation: obj["jobtitle"].toString(),
          salary: obj["salary"].toString(),
          contactNo: obj["guardian_contact"].toString(),
          gContact: obj["guardian_contact"].toString(),
          gName: obj["guardian_name"].toString(),
          gRelation: obj["guardian_name"].toString(),
          applicationDate: obj["applicationDate"].toString(),
          suggestion: suggestionList,
          committeeMemberName: committeeMemberName,
          suggestedAmount: suggestedAmount,
        );
        applicationList.add(a);
      }
    }
    return applicationList;
  }
/*  Future<List<Application>> getAllApplication() async {
    List<Application> applicationList = [];
    Response res = await AdminApiHandler().rejectedApplication();
    if (res.statusCode == 200) {
      dynamic response = jsonDecode(res.body);
      for (var obj in response) {
        String ss = '';
        String dc = '';
        List<String> hg = [];
        for (int i = 0; i < obj["re"]["EvidenceDocuments"].length; i++) {
          if (obj["re"]["EvidenceDocuments"][i]["document_type"] != null &&
              obj["re"]["EvidenceDocuments"][i]["image"] != null) {
            if (obj["re"]["EvidenceDocuments"][i]["document_type"] ==
                "salaryslip") {
              ss = obj["re"]["EvidenceDocuments"][i]["image"];
            } else if (obj["re"]["EvidenceDocuments"][i]["document_type"] ==
                "deathcertificate") {
              dc = obj["re"]["EvidenceDocuments"][i]["image"];
            } else if (obj["re"]["EvidenceDocuments"][i]["document_type"] ==
                "houseAgreement") {
              hg.add(obj["re"]["EvidenceDocuments"][i]["image"]);
            }
          }
        }
        List<String> suggestionList = [];
        for (int j = 0; j < obj["re"]["suggestion"].length; j++) {
          suggestionList.add(obj["re"]["suggestion"][j]["comment"].toString());
        }
        Application a = Application(
            applicationStatus: obj['applicationStatus'].toString(),
            profileImage: obj["re"]["profile_image"].toString(),
            name: obj["re"]["name"].toString(),
            status: obj["re"]["father_status"].toString(),
            semester: obj["re"]["semester"].toString(),
            degree: obj["re"]["degree"].toString(),
            fatherName: obj["re"]["father_name"].toString(),
            section: obj["re"]["section"].toString(),
            amount: obj["re"]["requiredAmount"].toString(),
            gender: obj["re"]["gender"].toString(),
            aridNo: obj["re"]["arid_no"].toString(),
            cgpa: obj["re"]["cgpa"].toString(),
            studentId: obj["re"]["student_id"].toString(),
            reason: obj["re"]["reason"].toString(),
            applicationID: obj["re"]["applicationID"].toString(),
            deathCertificate: dc,
            agreement: hg,
            salarySlip: ss,
            house: obj["re"]["house"].toString(),
            occupation: obj["re"]["jobtitle"].toString(),
            salary: obj["re"]["salary"].toString(),
            contactNo: obj["re"]["guardian_contact"].toString(),
            gContact: obj["re"]["guardian_contact"].toString(),
            gName: obj["re"]["guardian_name"].toString(),
            gRelation: obj["re"]["guardian_name"].toString(),
            applicationDate: obj["re"]["applicationDate"].toString(),
            suggestion: suggestionList);
        applicationList.add(a);
      }
    }
    return applicationList;
  }*/


  Future<List<Student>> meritBaseRejectedApplication()async{
    List<Student> list=[];
    Response res=await AdminApiHandler().getMeritBaseRejectedApplication();

    if(res.statusCode==200)
    {
      dynamic obj=jsonDecode(res.body);
      for(var i in obj)
      {
        Student s= Student(
            aridNo: i['arid_no'].toString(),
            name: i['name'].toString(),
            semester: int.parse(i['semester'].toString()),
            cgpa: double.parse(i['cgpa'].toString()),
            section: i['section'].toString(),
            degree: i['degree'].toString(),
            fatherName: i['father_name'].toString(),
            gender: i['gender'].toString(),
            studentId: int.parse(i['student_id'].toString()),
            profileImage: i['profile_image'].toString()
        );
        list.add(s);
      }
    }
    return list;
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, RouteName.committeeHeadDashBoard);
              },
              child: const Icon(Icons.arrow_back)),
          title: const Text("Rejected Application"),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          bottom:const TabBar(
            tabs: [
              Tab(
                child: Text("NeedBase"),
              ),
              Tab(
                child: Text("MeritBase"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding:
                  EdgeInsets.only(top: CustomSize().customHeight(context) / 45),
                  child: Center(
                    child: Container(
                      height: CustomSize().customHeight(context) / 8,
                      width: CustomSize().customWidth(context) / 1.13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            CustomSize().customHeight(context) / 80),
                        color: Colors.blueGrey.withOpacity(0.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            spreadRadius: CustomSize().customHeight(context) / 1000,
                            blurRadius: CustomSize().customHeight(context) / 100,
                            offset: Offset(CustomSize().customHeight(context) / 1400,
                                CustomSize().customHeight(context) / 1400),
                          ),
                        ],
                      ),
                      child: FutureBuilder(
                        future: getAllApplication(),
                        builder: (context, snapshot) {
                          return Column(
                            children: [
                              Center(
                                  child: Text(
                                    "Total Rejected",
                                    style: TextStyle(
                                        fontSize: CustomSize().customHeight(context) / 30,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  )),
                              Center(
                                  child: Text(
                                    snapshot.data?.length.toString() ?? "",
                                    style: TextStyle(
                                        fontSize: CustomSize().customHeight(context) / 30,
                                        fontStyle: FontStyle.italic),
                                  )),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: CustomSize().customWidth(context) / 20,
                      right: CustomSize().customWidth(context) / 20,
                      top: CustomSize().customWidth(context) / 30),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {});
                    },
                    controller: _search,
                    decoration: InputDecoration(
                      hintText: "search",
                      labelText: "search",
                      suffixIcon: Icon(Icons.search,
                          size: CustomSize().customWidth(context) / 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            CustomSize().customHeight(context) / 60),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: FutureBuilder(
                      future: getAllApplication(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data ?? [];
                          var filteredList = data.where((item) => item.name.toLowerCase().contains(_search.text.toLowerCase())).toList();
                          return ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(
                                    CustomSize().customHeight(context) / 80),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return NeedBaseApplicationDetails(
                                              application: filteredList[index],
                                              isTrue: true,
                                              trackRecord: false,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      title: Container(
                                        height:
                                        CustomSize().customHeight(context) / 4.5,
                                        width: CustomSize().customWidth(context) / 1.13,
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.withOpacity(0.2),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white,
                                              spreadRadius:
                                              CustomSize().customHeight(context) /
                                                  1000,
                                              blurRadius:
                                              CustomSize().customHeight(context) /
                                                  100,
                                              offset: Offset(
                                                  CustomSize().customHeight(context) /
                                                      1400,
                                                  CustomSize().customHeight(context) /
                                                      1400),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(
                                              CustomSize().customHeight(context) / 80),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height:
                                              CustomSize().customHeight(context) /
                                                  8,
                                              width: CustomSize().customWidth(context) /
                                                  1.12,
                                              decoration: BoxDecoration(
                                                color: Colors.blueGrey.withOpacity(0.2),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white,
                                                    spreadRadius: CustomSize()
                                                        .customHeight(context) /
                                                        1000,
                                                    blurRadius: CustomSize()
                                                        .customHeight(context) /
                                                        100,
                                                    offset: Offset(
                                                        CustomSize()
                                                            .customHeight(context) /
                                                            1400,
                                                        CustomSize()
                                                            .customHeight(context) /
                                                            1400),
                                                  ),
                                                ],
                                              ),
                                              child: filteredList[index].agreement[0]
                                                  .split('.')[1] ==
                                                  "pdf"
                                                  ? const Image(
                                                image:
                                                AssetImage("Assets/pdf2.png"),
                                                fit: BoxFit.fill,
                                              )
                                                  : filteredList[index].agreement[0]
                                                  .split('.')[1] ==
                                                  "docx"
                                                  ? const Image(
                                                  image: AssetImage(
                                                      "Assets/docx1.png"))
                                                  : EndPoint.houseAgreement +
                                                  filteredList[index]
                                                      .agreement[0] !=
                                                  EndPoint
                                                      .houseAgreement ||
                                                  EndPoint.houseAgreement +
                                                      filteredList[index]
                                                          .agreement[0] !=
                                                      "${EndPoint.houseAgreement}/null"
                                                  ? Image(
                                                  height:
                                                  CustomSize().customHeight(context) / 4.5,
                                                  width: CustomSize().customWidth(context) / 1.13,
                                                  image: NetworkImage(EndPoint.houseAgreement + filteredList[index].agreement[0]),
                                                  fit: BoxFit.fill)
                                                  : const Image(image: AssetImage("Assets/c1.png")),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: CustomSize()
                                                      .customHeight(context) /
                                                      80),
                                              child: Text(
                                                filteredList[index].name ?? "",
                                                style: TextStyle(
                                                    fontSize: CustomSize()
                                                        .customHeight(context) /
                                                        50,
                                                    fontStyle: FontStyle.italic),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: CustomSize()
                                                      .customHeight(context) /
                                                      80),
                                              child: Text(
                                                filteredList[index].aridNo ?? "",
                                                style: TextStyle(
                                                    fontSize: CustomSize()
                                                        .customHeight(context) /
                                                        50,
                                                    fontStyle: FontStyle.italic),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding:
                  EdgeInsets.only(top: CustomSize().customHeight(context) / 45),
                  child: Center(
                    child: Container(
                      height: CustomSize().customHeight(context) / 8,
                      width: CustomSize().customWidth(context) / 1.13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            CustomSize().customHeight(context) / 80),
                        color: Colors.blueGrey.withOpacity(0.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            spreadRadius: CustomSize().customHeight(context) / 1000,
                            blurRadius: CustomSize().customHeight(context) / 100,
                            offset: Offset(CustomSize().customHeight(context) / 1400,
                                CustomSize().customHeight(context) / 1400),
                          ),
                        ],
                      ),
                      child: FutureBuilder(
                        future: meritBaseRejectedApplication(),
                        builder: (context, snapshot) {
                          return Column(
                            children: [
                              Center(
                                  child: Text(
                                    "Total Rejected",
                                    style: TextStyle(
                                        fontSize: CustomSize().customHeight(context) / 30,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  )),
                              Center(
                                  child: Text(
                                    snapshot.data?.length.toString() ?? "",
                                    style: TextStyle(
                                        fontSize: CustomSize().customHeight(context) / 30,
                                        fontStyle: FontStyle.italic),
                                  )),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: CustomSize().customWidth(context) / 20,
                      right: CustomSize().customWidth(context) / 20,
                      top: CustomSize().customWidth(context) / 30),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {});
                    },
                    controller: _search,
                    decoration: InputDecoration(
                      hintText: "search",
                      labelText: "search",
                      suffixIcon: Icon(Icons.search,
                          size: CustomSize().customWidth(context) / 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            CustomSize().customHeight(context) / 60),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: FutureBuilder(
                      future: meritBaseRejectedApplication(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data ?? [];
                          var filteredList1 = data.where((item) => item.name.toLowerCase().contains(_search.text.toLowerCase())).toList();
                          return ListView.builder(
                            itemCount: filteredList1.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(left:CustomSize().customWidth(context)/40,right: CustomSize().customWidth(context)/40,top: CustomSize().customWidth(context)/100,bottom: CustomSize().customWidth(context)/100),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:filteredList1[index].semester>8 || filteredList1[index].cgpa<2.0?Colors.red:Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(CustomSize().customWidth(context)/20),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: CustomSize().customHeight(context) / 30,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            CustomSize().customHeight(context) / 30),
                                        child:EndPoint.imageUrl+filteredList1[index].profileImage==
                                            EndPoint.imageUrl+"null"||EndPoint.imageUrl+filteredList1[index].profileImage==EndPoint.imageUrl?(
                                            filteredList1[index].gender=='M'?Image.asset("Assets/male.png"):Image.asset("Assets/female.png"))
                                            :Image(
                                          image: NetworkImage(EndPoint.imageUrl + filteredList1[index].profileImage),
                                          width: CustomSize().customHeight(context) / 12,//CustomSize().customHeight(context)/15
                                          height: CustomSize().customHeight(context) / 12,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    title: Text(filteredList1[index].name),
                                    subtitle: Text(filteredList1[index].aridNo),

                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )),
              ],
            ),
          ],
        )
      ),
    );
  }
}
