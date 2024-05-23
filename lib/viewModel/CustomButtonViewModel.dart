
import 'package:flutter/cupertino.dart';

class CustomButtonViewModel with ChangeNotifier{

  bool _loading=false;

  bool get loading=>_loading;

  setLoading(bool val){
    _loading=val;
    notifyListeners();
  }
}