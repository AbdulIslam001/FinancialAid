import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Resources/AppUrl.dart';

class FacultyApiHandler {
  Future<http.Response> getFacultyInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    int id = int.parse(sp.getInt('id').toString());
    String apiEndPoint = EndPoint.facultyInfo + "?id=$id";
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }

  Future<http.Response> getGraderInformation() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    int id = int.parse(sp.getInt('id').toString());
    String apiEndPoint = EndPoint.getGraderInfo+ "?id=$id";
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.get(uri);
    return response;
  }
  Future<int> rateGraderPerformance(String comment,String studentId,String facultyId,String rating) async {
    String apiEndPoint = EndPoint.rateGraderPerformance+"?facultyId=$facultyId&studentId=$studentId&rate=$rating&comment=$comment";
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.post(uri);
    return response.statusCode;
  }
}
