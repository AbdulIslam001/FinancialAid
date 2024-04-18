

import 'dart:convert';
import 'dart:io';

import 'package:financial_aid/Resources/AppUrl.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';


class AdminApiHandler{

//////////////Student//////////////////


  Future<http.Response> getAllStudent()async{
    String apiEndPoint = EndPoint.getAllStudents;
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.get(uri);
    return response;
  }

  Future<http.Response> getAdminInfo()async{
    SharedPreferences sp =await SharedPreferences.getInstance();
    String apiEndPoint = EndPoint.getAdminInfo + "?id=" + sp.getInt('id').toString();
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.get(uri);
    return response;
  }

  Future<int> updatePassword(int id , String userName, String password)async{
    String apiEndPoint = EndPoint.updatePassword + "?id="+id.toString()+"&username="+userName+"&password="+password;
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.post(uri);
    return response.statusCode;
  }


//////////////Budget//////////////////


  Future<http.Response> getAllBudget()async{
    String apiEndPoint = EndPoint.getAllBudget;
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.get(uri);
    return response;
  }

//////////////Faculty//////////////////
  Future<int> addFacultyMember(String name , String contactNo,String password , File image)async{
    String apiEndPoint = EndPoint.addFacultyMember;
    Uri uri=Uri.parse(apiEndPoint);
    http.MultipartRequest request=http.MultipartRequest('POST',uri);
    request.fields["name"]=name;
    request.fields["contact"]=contactNo;
    request.fields["password"]=password;
    http.MultipartFile pic=await http.MultipartFile.
    fromPath("pic",image.path);
    request.files.add(pic);
    var response =await request.send();
    return response.statusCode;
  }

  Future<http.Response> getAllFaculty()async{
    String apiEndPoint = EndPoint.getFacultyMembers;
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.get(uri);
    return response;
  }

  Future<http.Response> getCommitteeMembers()async{
    String apiEndPoint = EndPoint.getCommitteeMembers;
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.get(uri);
    return response;
  }
  Future<int> addCommitteeMember(int id)async{
    String apiEndPoint = EndPoint.AddCommitteeMember+"?id=${id.toString()}";
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.post(uri);
    return response.statusCode;
  }

  Future<http.Response> getApplications()async{
    String apiEndPoint=EndPoint.adminApplication;
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.get(uri);
    return response;
  }

  Future<int> rejectApplication(int id)async{
    String apiEndPoint=EndPoint.rejectApplication+"?applicationid=$id";
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.post(uri);
    return response.statusCode;
  }

  Future<int> acceptApplication(int id , int amount)async{
    String apiEndPoint=EndPoint.acceptApplication+"?amount=$amount&applicationid=$id";
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.post(uri);
    return response.statusCode;
  }

  Future<http.Response> acceptedApplication()async{
    String apiEndPoint=EndPoint.accepted;
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.get(uri);
    return response;
  }

  Future<http.Response> rejectedApplication()async{
    String apiEndPoint=EndPoint.rejected;
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.get(uri);
    return response;
  }
}

