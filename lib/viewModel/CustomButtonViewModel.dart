
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

class CustomButtonViewModel with ChangeNotifier{

  bool _loading=false;

  bool get loading=>_loading;

  setLoading(bool val){
    _loading=val;
    notifyListeners();
  }

  bool _isPicked=false;

  bool get isPicked=>_isPicked;

  setIsPicked(bool val){
    _isPicked=val;
    notifyListeners();
  }

  File? _pickFile;

  get pickFile=>_pickFile;

  Future<void> setPickFile()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls','xlsx'],
    );
    if (result != null) {
      File file = File(result.files.single.path!,);
      _pickFile=File(file.path);
      setIsPicked(true);
      notifyListeners();
    }
  }
}