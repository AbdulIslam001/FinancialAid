

import 'package:flutter/cupertino.dart';

class NeedBaseTotalAmount extends ChangeNotifier{

  int _totalAmount=0;

  get totalAmount=>_totalAmount;

  setTotalAmount(){
    _totalAmount=0;
  }
  setAmount(int val){
    _totalAmount+=val;
//    notifyListeners();
  }

}