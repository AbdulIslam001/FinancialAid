

import 'package:flutter/cupertino.dart';

class NeedBaseTotalAmount/* extends ChangeNotifier*/{


  int _needBaseTotalAmount=0;
  get needBaseTotalAmount=>_needBaseTotalAmount;
  set setNeedBaseTotalAmount(int val){
    _needBaseTotalAmount+=val;
  }

  int _meritBaseTotalAmount=0;
  get meritBaseTotalAmount=>_meritBaseTotalAmount;
  set setMeritBaseTotalAmount(int val){
    _meritBaseTotalAmount+=val;
  }


  int _nGirl=0;
  get nGirls=>_nGirl;
  setNGirls(){
    _nGirl++;
  }


  int _nBoy=0;
  get nBoys=>_nBoy;
  setNBoys(){
    _nBoy++;
  }


  int _totalNeedBase=0;
  get totalNeedBase=>_totalNeedBase;
  setTotalNeedBase(int val){
    _totalNeedBase+=val;
  }

  int _nGirlsAmount=0;
  get nGirlsAmount=>_nGirlsAmount;
  setNGirlsAmount(int val){
    _nGirlsAmount+=val;
  }

  int _nBoysAmount=0;
  get nBoysAmount=>_nBoysAmount;
  setNBoysAmount(int val){
  _nBoysAmount+=val;
  }

  int _mGirl=0;
  get mGirls=>_mGirl;
  setMGirls(){
    _mGirl++;
  }

  int _mBoy=0;
  get mBoys=>_mBoy;
  setMBoys(){
    _mBoy++;
  }

  int _totalMeritBase=0;
  get totalMeritBase=>_totalMeritBase;
  setTotalMeritBase(int val){
    _totalMeritBase+=val;
  }

  int _mBoysAmount=0;
  get mBoysAmount=>_mBoysAmount;
  setMBoysAmount(int val){
    _mBoysAmount+=val;
  }

  int _mGirlsAmount=0;
  get mGirlsAmount=>_mGirlsAmount;
  setMGirlsAmount(int val){
    _mGirlsAmount+=val;
  }




  /*


  int _totalAmount=0;

  get totalAmount=>_totalAmount;

  setTotalAmount(){
    _totalAmount=0;
  }
  setAmount(int val){
    _totalAmount+=val;
//    notifyListeners();
  }*/

}