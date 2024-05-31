
import 'dart:convert';

import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Resources/AppUrl.dart';

class CommitteeApiHandler{

Future<http.Response> getBalance()async{
  String apiEndPoint=EndPoint.getBalance;
  Uri uri=Uri.parse(apiEndPoint);
  var response=await http.get(uri);
  return response;
}

Future<http.Response> switchRole()async{
  SharedPreferences sp =await SharedPreferences.getInstance();
  int id= int .parse(sp.getInt('id').toString());
  String apiEndPoint=EndPoint.switchRole+"?memberid=$id";
  Uri uri=Uri.parse(apiEndPoint);
  var response=await http.post(uri);
  return response;
}

  Future<http.Response> committeeMemberInfo()async{
    SharedPreferences sp =await SharedPreferences.getInstance();
    int id= int .parse(sp.getInt('id').toString());
    String apiEndPoint=EndPoint.committeeMemberInfo+"?id=$id";
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.get(uri);
    return response;
  }

  Future<http.Response> getAllApplications()async{
    SharedPreferences sp =await SharedPreferences.getInstance();
    int id= int .parse(sp.getInt('id').toString());
    String apiEndPoint=EndPoint.getApplication+"?id=$id";
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.get(uri);
    return response;
  }

  Future<int> giveSuggestion(String comment,String status,int applicationId, int amount)async{
    SharedPreferences sp =await SharedPreferences.getInstance();
    int id= int .parse(sp.getInt('id').toString());
    String apiEndPoint=EndPoint.giveSuggestion+"?committeeId=$id&status=$status&applicationId=$applicationId&comment=$comment&amount=$amount";
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.post(uri);
    return response.statusCode;
  }

}