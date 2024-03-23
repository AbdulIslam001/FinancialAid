


import 'package:http/http.dart'as http;

import '../Resources/AppUrl.dart';


class LoginApiHandler{

  Future<http.Response> login(String name, String password)async
  {
    String apiEndPoint=EndPoint.login+"?username=$name&password=$password";
    Uri uri= Uri.parse(apiEndPoint);
    var response=await http.get(uri);
    return response;
  }
}
