

import 'dart:convert';

import 'package:http/http.dart';

import '../../Models/ApplicationModel.dart';
import '../../Services/Admin/AdminApiHandler.dart';

class ApplicationHistory{
  Future<List<Application>> getAllApplication(int id)async{
    List<Application> applicationList=[];
    Response res=await AdminApiHandler().getApplicationHistory(id);
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
        for(int j=0;j<obj["Suggestions"].length;j++){
          suggestionList.add(obj["Suggestions"][j]["comment"].toString());
          committeeMemberName.add(obj["Suggestions"][j]["CommitteeMemberName"].toString());
          isApplication.add(obj["Suggestions"][j]["status"].toString());
        }
        Application a = Application(
          isApplication: isApplication,
           applicationStatus: obj['applicationStatus'].toString(),
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
          session: obj["session"].toString(),
        );
        applicationList.add(a);
      }
    }
    return applicationList;
  }
}