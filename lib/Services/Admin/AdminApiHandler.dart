

import 'dart:convert';
import 'dart:io';

import 'package:financial_aid/Models/PolicyModel.dart';
import 'package:financial_aid/Resources/AppUrl.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/ApplicationModel.dart';


class AdminApiHandler {

//////////////Student//////////////////


  Future<http.Response> getAllStudent() async {
    String apiEndPoint = EndPoint.getAllStudents;
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

  Future<http.Response> getAdminInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String apiEndPoint = EndPoint.getAdminInfo + "?id=" +
        sp.getInt('id').toString();
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

  Future<int> updatePassword(int id, String userName, String password) async {
    String apiEndPoint = EndPoint.updatePassword + "?id=" + id.toString() +
        "&username=" + userName + "&password=" + password;
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.post(uri);
    return response.statusCode;
  }


//////////////Budget//////////////////


  Future<http.Response> getAllBudget() async {
    String apiEndPoint = EndPoint.getAllBudget;
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

//////////////Faculty//////////////////


  Future<int> addFacultyMember(String name, String contactNo, String password,
      File image) async {
    String apiEndPoint = EndPoint.addFacultyMember;
    Uri uri = Uri.parse(apiEndPoint);
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.fields["name"] = name;
    request.fields["contact"] = contactNo;
    request.fields["password"] = password;
    http.MultipartFile pic = await http.MultipartFile.
    fromPath("pic", image.path);
    request.files.add(pic);
    var response = await request.send();
    return response.statusCode;
  }

  Future<http.Response> getAllFaculty() async {
    String apiEndPoint = EndPoint.getFacultyMembers;
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

  Future<http.Response> unAssignedFaculty() async {
    String apiEndPoint = EndPoint.unAssignedFacultyMember;
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

  Future<http.Response> getCommitteeMembers() async {
    String apiEndPoint = EndPoint.getCommitteeMembers;
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

  Future<int> addCommitteeMember(int id) async {
    String apiEndPoint = EndPoint.AddCommitteeMember + "?id=${id.toString()}";
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.post(uri);
    return response.statusCode;
  }

  Future<http.Response> getApplications() async {
    String apiEndPoint = EndPoint.adminApplication;
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

  Future<int> rejectApplication(int id) async {
    String apiEndPoint = EndPoint.rejectApplication + "?applicationid=$id";
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.post(uri);
    return response.statusCode;
  }

  Future<int> acceptApplication(int id, int amount) async {
    String apiEndPoint = EndPoint.acceptApplication +
        "?amount=$amount&applicationid=$id";
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.post(uri);
    return response.statusCode;
  }

  Future<http.Response> acceptedApplication() async {
    String apiEndPoint = EndPoint.accepted;
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

  Future<http.Response> rejectedApplication() async {
    String apiEndPoint = EndPoint.rejected;
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

  Future<int> addStudent(String name,
      String password,
      String aridNo,
      String semester,
      String gender,
      String section,
      File image,
      String fatherName,
      String degree,
      String cgpa) async {
    String apiEndPoint = EndPoint.addStudent;
    Uri uri = Uri.parse(apiEndPoint);
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.fields["name"] = name;
    request.fields["cgpa"] = cgpa;
    request.fields["semester"] = semester;
    request.fields["aridno"] = aridNo;
    request.fields["gender"] = gender;
    request.fields["fathername"] = fatherName;
    request.fields["degree"] = degree;
    request.fields["section"] = section;
    request.fields["password"] = password;
    http.MultipartFile pic = await http.MultipartFile.
    fromPath("pic", image.path);
    request.files.add(pic);
    var response = await request.send();
    return response.statusCode;
  }

  Future<int> addPolicy(String description, String val1, String val2,
      String policyFor, String policy, String strength) async {
    String apiEndPoint = "${EndPoint
        .addPolicies}?description=$description&val1=$val1&val2=$val2&policyFor=$policyFor&policy=$policy&strength=$strength";
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.post(uri);
    return response.statusCode;
  }

  Future<http.Response> getPolicies() async {
    String apiEndPoint = EndPoint.getPolicies;
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

  Future<http.Response> getUnAssignedStudent() async {
    String apiEndPoint = EndPoint.unAssignedStudents;
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

  Future<int> assignGrader(int studentId, int facultyId) async {
    String apiEndPoint = EndPoint.assignGrader +
        "?facultyId=$facultyId&StudentId=$studentId";
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.post(uri);
    return response.statusCode;
  }

  Future<int> addBudget(int amount) async {
    String apiEndPoint = "${EndPoint.addBudget}?amount=$amount";
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.post(uri);
    return response.statusCode;
  }

  Future<http.Response> getMeritBaseShortListed() async {
    String apiEndPoint = EndPoint.getMeritBaseShortListedStudent;
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

  Future<http.Response> doMeritBaseShortListing() async {
    String apiEndPoint = EndPoint.meritBaseShortListing;
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.post(uri);
    return response;
  }

  Future<int> removeGrader(int id) async {
    String apiEndPoint = EndPoint.removeGrader + "?id=$id";
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.post(uri);
    return response.statusCode;
  }


  Future<int> addSession(String title, String start, String end) async {
    List<String> last = start.split('/');
    String lastDate = last[0].toString() + "/" +
        (int.parse(last[1]) + 1).toString() + "/" + last[2].toString();
    String apiEndPoint = "${EndPoint.addSession}?name=$title-${DateTime(DateTime
        .now()
        .year).toString().split(
        '-')[0]}&startDate=$start&EndDate=$end&lastDate=${lastDate}";
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.post(uri);
    return response.statusCode;
  }

  Future<int> checkBalance() async {
    String apiEndPoint = EndPoint.meritBaseAmmount;
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response.statusCode;
  }
  Future<http.Response> getApplicationHistory(int id) async {
    String apiEndPoint = "${EndPoint.getApplicationHistory}?id=$id";
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }
}