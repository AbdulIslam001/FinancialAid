

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerViewModel with ChangeNotifier{

  bool _loading=false;

  final imagePicker=ImagePicker();

  int _length=0;

  get length=>_length;

  setLength(int l){
    _length=l;
    notifyListeners();
  }
//  File? _pickedCertificate;

  File? _pickedDocs;

  File? _pickedAgreement;

  List<File> _houseAgreement=[];

  get houseAgreement=>_houseAgreement;

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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'docx','jpeg','png'],
    );

    if (result != null) {
      File file = File(result.files.single.path!,);
      _pickedDocs=File(file.path);
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

  Future<void> setDocs1()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'docx','jpeg','png'],
    );

    if (result != null) {
      File file = File(result.files.single.path!,);
      _pickedDocs=File(file.path);
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

  Future<void> setAgreement1()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'docx','jpeg','png'],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      for(int i =0; i<files.length;i++){
        _houseAgreement.add(files[i]);
      }
      setLength(files.length);
    }
    setAgreementStatus(true);
    notifyListeners();
  }

}