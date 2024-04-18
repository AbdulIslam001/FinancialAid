
import 'dart:io';

import 'EvidenceDocument.dart';

class App{
  String name;
  String aridNumber;
  App({required this.name, required this.aridNumber});
}

class Application{
String applicationDate;
  String aridNo;
  String name;
  String fatherName;
  String cgpa;
  String semester;
  String gender;
  String degree;
  String section;
  String profileImage;
  String  studentId;
  String status;
  String? occupation;
  String? contactNo;
  String? salary;
//List<EvidenceDocument?> documents;
  String? salarySlip;
  String? deathCertificate;
  String? gName;
  String? gContact;
  String? gRelation;
  String house;
  String agreement;
  String reason;
  String amount;
  String applicationID;
  List<String>? suggestion;
  String? applicationStatus;

  Application({this.applicationStatus,
    required this.applicationDate,required this.applicationID,this.suggestion,
  required this.profileImage,required this.name,required this.status,required this.semester,required this.degree,required this.fatherName,required this.section,required this.amount,required this.gender,required this.aridNo,required this.cgpa,
    required this.studentId, required this.reason, required this.house,
    required this.occupation, required this.deathCertificate,required this.salary,required this.agreement,
    required this.salarySlip, required this.contactNo,required this.gContact, required this.gName,required this.gRelation});
}
