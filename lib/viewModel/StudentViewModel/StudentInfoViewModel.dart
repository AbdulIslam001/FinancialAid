


import 'package:flutter/cupertino.dart';

class StudentInfoViewModel with ChangeNotifier{

  String _name='';
  String _aridNo='';


  get getName=>_name;
  get getAridNo=>_aridNo;

  setStudentInfo(String name,String arid)
  {
    _name=name;
    _aridNo=arid;
    notifyListeners();
  }
}