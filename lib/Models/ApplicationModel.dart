
import 'dart:io';

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
  String? salarySlip;
  String? deathCertificate;
  String? gName;
  String? gContact;
  String? gRelation;
  String house;
  String agreement;
  String reason;
  String? amount;

  Application({
    required this.applicationDate,
  required this.profileImage,required this.name,required this.status,required this.semester,required this.degree,required this.fatherName,required this.section,required this.amount,required this.gender,required this.aridNo,required this.cgpa,
    required this.studentId, required this.reason,required this.agreement,
    required this.house,required this.occupation,required this.deathCertificate,
    required this.salarySlip,required this.salary,required this.contactNo,required this.gContact,
    required this.gName,required this.gRelation});
}