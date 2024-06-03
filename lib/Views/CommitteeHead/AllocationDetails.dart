
import "dart:convert";

import "package:financial_aid/Resources/CustomSize.dart";
import "package:flutter/material.dart";
import "package:http/http.dart";

import "../../Models/ApplicationModel.dart";
import "../../Services/Admin/AdminApiHandler.dart";


    class AllocationDetails extends StatelessWidget {
      String session;
      AllocationDetails({super.key,required this.session});

      Future<List<Application>> acceptedApplication()async{
        List<Application> applicationList=[];
        Response res=await AdminApiHandler().acceptedApplication();
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
                  dc=obj["re"]["EvidenceDocuments"][i]["image"];
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
//           applicationStatus: obj['applicationStatus'].toString(),
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
              exemptedAmount: int.parse(obj["amount"].toString()),
              prevCgpa: obj["prev_cgpa"].toString(),
              suggestion: suggestionList,
              committeeMemberName: committeeMemberName,
              suggestedAmount: suggestedAmount,
            );
            applicationList.add(a);
          }
        }
        return applicationList;
      }

      Future<List<Application>> rejectedApplication()async{
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
                  dc=obj["re"]["EvidenceDocuments"][i]["image"];
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
      @override
      Widget build(BuildContext context) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColor,
              title:const Text("Allocation Details"),
              bottom:const TabBar(
                tabs: [
                  Tab(
                    child: Text("NeedBase"),
                  ),
                  Tab(
                    child: Text("MeritBase"),
                  ),
                  Tab(
                    child: Text("summary"),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: acceptedApplication(), builder: (context, snapshot) {
                          if(snapshot.hasData)
                          {
                            return DataTable(
                              columnSpacing: CustomSize().customWidth(context)/40,
                              columns: const [
                                DataColumn(label: Text("Arid No")),
                                DataColumn(label: Text("Name")),
                                DataColumn(label: Text("Discipline")),
                                DataColumn(label: Text("Gender")),
                                DataColumn(label: Text("current\ncgpa")),
                                DataColumn(label: Text("previous\ncgpa")),
                                DataColumn(label: Text("Fee\nExempted")),
                              ],rows:snapshot.data!.map((item) {
                              return DataRow(
                                  cells: [
                                    DataCell(Text(item.aridNo.toString())),
                                    DataCell(Text(item.name.toString())),
                                    DataCell(Text(item.degree.toString())),
                                    DataCell(Text(item.gender.toString())),
                                    DataCell(Text(item.cgpa.toString())),
                                    DataCell(Text(item.prevCgpa.toString())),
                                    DataCell(Text(item.exemptedAmount.toString())),

                                  ]);
                            }).toList(),
                            );
                          }else{
                            return const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator()
                                ],
                              );
                          }
                      },)
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      DataTable(
                          columnSpacing: CustomSize().customWidth(context)/40,
                          columns: const [
                            DataColumn(label: Text("Name")),
                            DataColumn(label: Text("Discipline")),
                            DataColumn(label: Text("Gender")),
                            DataColumn(label: Text("current\ncgpa")),
                            DataColumn(label: Text("previous\ncgpa")),
                            DataColumn(label: Text("position")),
                            DataColumn(label: Text("Fee\nExempted")),
                          ],rows:[]
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: CustomSize().customWidth(context)/5),
                        child: Text("$session Allocation Summary",style:const TextStyle(fontWeight: FontWeight.bold,)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
