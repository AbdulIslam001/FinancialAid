

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerViewModel with ChangeNotifier{

  bool _loading=false;

  final imagePicker=ImagePicker();

//  File? _pickedCertificate;

  File? _pickedDocs;

  File? _pickedAgreement;

  bool _certificateStatus=false;

  bool _slipStatus=false;

  bool _houseAgreementStatus=false;

  get certificateStatus=>_certificateStatus;

  get houseAgreementStatus=>_houseAgreementStatus;


  get slipStatus=>_slipStatus;

 // get pickedCertificate=>_pickedCertificate;

  get pickedDocs=>_pickedDocs;

  get pickedAgreement=>_pickedAgreement;

 // get pickedEvidence=>_pickedEvidence;

  get loading=>_loading;


  setLoading(bool val){
    _loading=val;
    notifyListeners();
  }

  setAgreementStatus(bool status){
    _houseAgreementStatus=status;
    notifyListeners();
  }

  setSlipStatus(bool status){
    _slipStatus=status;
    notifyListeners();
  }

  setCertificateStatus(bool status){
    _certificateStatus=status;
    notifyListeners();
  }

  Future<XFile?> pickSingleFile()async{
    XFile? picked=await imagePicker.pickImage(source: ImageSource.gallery);
    return picked;
  }

  Future<List<XFile?>> pickMultipleFile()async{
    final pickedImage=await imagePicker.pickMultiImage();
    List<XFile> xFiles=pickedImage;
      return xFiles;
  }

  Future<void> setDeathCertificate()async{

    XFile? deathCertificate=await pickSingleFile();
    if(deathCertificate!=null)
    {
      _pickedDocs=File(deathCertificate.path);
      setCertificateStatus(true);
      setSlipStatus(false);
      notifyListeners();
    }
  }

  Future<void> setDocs()async{
    XFile? salarySip=await pickSingleFile();
    if(salarySip!=null)
    {
      _pickedDocs=File(salarySip.path);
      setSlipStatus(true);
      setCertificateStatus(false);
      notifyListeners();
    }
  }

  Future<void> setAgreement()async{
    XFile? agreement=await pickSingleFile();
        _pickedAgreement=File(agreement!.path);
      setAgreementStatus(true);
      notifyListeners();
  }

}