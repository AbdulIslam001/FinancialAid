
import 'package:flutter/cupertino.dart';

class AddCommitteeViewModel with ChangeNotifier{

  bool _isTrue=false;

  get isTrue=>_isTrue;

  setIsTrue(bool val){

    _isTrue=val;
    notifyListeners();
  }


}