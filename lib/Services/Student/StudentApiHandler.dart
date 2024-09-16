import 'dart:io';

import 'package:financial_aid/Models/ApplicationModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Resources/AppUrl.dart';

class StudentApiHandle {
  Future<http.Response> getStudentInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String apiEndPoint = EndPoint.getStudentInfo + "?id=" + sp.getInt('id').toString();
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

  Future<int> sendApplication(int length,bool isPicked,String status,String? occupation,String? contactNo,String? salary,File? docs,String? gName, String? gContact, String? gRelation, String house,List<File> agreement,
    String reason, String amount, String studentId,) async {
    String apiEndPoint = EndPoint.sendApplication;
    Uri uri=Uri.parse(apiEndPoint);
    http.MultipartRequest request=http.MultipartRequest('POST',uri);
    request.fields["status"]=status;
    request.fields["occupation"]=occupation??"";
    request.fields["contactNo"]=contactNo??"";
    request.fields["salary"]=salary??"";
    request.fields["gName"]=gName??"";
    request.fields["gContact"]=gContact??"";
    request.fields["gRelation"]=gRelation??"";
    request.fields["reason"]=reason;
    request.fields["amount"]=amount;
    request.fields["studentId"]=studentId;
    request.fields["house"]=house;
    request.fields["isPicked"]=isPicked.toString();
    request.fields["length"]=length.toString();

    if(status=='Alive' && isPicked ){
      http.MultipartFile ss=await http.MultipartFile.
      fromPath("docs",docs!.path);
      request.files.add(ss);
    }else if(status == 'Deceased'){
      http.MultipartFile ss=await http.MultipartFile.
      fromPath("docs",docs!.path);
      request.files.add(ss);
    }
    for(int i=0;i<length;i++){
      http.MultipartFile a=await http.MultipartFile.
      fromPath("agreement$i",agreement[i].path);
      request.files.add(a);
    }
    var response =await request.send();
    return response.statusCode;
  }

  Future<http.Response> checkCgpaPolicy()async{

    String apiEndPoint=EndPoint.checkCgpaPolicy;
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

  Future<int> decideMeritBaseApplication(String status)async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String id=sp.getInt('id').toString();
    String apiEndPoint=EndPoint.accpetMeritBaseApplication+"?id=$id&status=$status";
    Uri uri = Uri.parse(apiEndPoint);
    var response=await http.post(uri);
    return response.statusCode;
  }


  Future<http.Response> applicationStatus()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String apiEndPoint =
        EndPoint.checkApplicationStatus + "?id=" + sp.getInt('id').toString();
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

  Future<int> updateProfilePic(int id,File image)async
  {
    String apiEndPoint=EndPoint.updateProfileImage;
    Uri url = Uri.parse(apiEndPoint);
    http.MultipartRequest request = http.MultipartRequest('POST', url);
    request.fields["id"] = id.toString();
    http.MultipartFile imageFile =
    await http.MultipartFile.fromPath("image", image.path);
    request.files.add(imageFile);
    var response = await request.send();
    return response.statusCode;
  }
}
