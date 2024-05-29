
import 'package:flutter/cupertino.dart';

class ViewSuggestionViewModel with ChangeNotifier{

  List<bool> _isShow=[];

  get isShow=>_isShow;

  setIsShow(int index,bool val){
    _isShow[index]=val;
    notifyListeners();
  }
}