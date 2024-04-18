

import 'package:flutter/cupertino.dart';

class ApplicationViewModel with ChangeNotifier{

  bool _isTrue=false;

  get isTrue=>_isTrue;

  setIsTrue(bool val){
    _isTrue=val;
    notifyListeners();
  }

  String _titleText="View Application";

  get titleText=>_titleText;

  setTitleText(){
     isTrue?_titleText="Show Less":_titleText="View Application";
    notifyListeners();
  }

}