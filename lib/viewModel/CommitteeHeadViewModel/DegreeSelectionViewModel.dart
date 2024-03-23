

import 'package:flutter/material.dart';

class DegreeViewModel with ChangeNotifier{

  String _selectedValue="";

  get selectedValue=>_selectedValue;

  setSelectedValue(String value){
    _selectedValue=value;
    notifyListeners();
  }
}