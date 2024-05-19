

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class FileDownloader{

  Future<bool> _requestPermission(Permission permission) async{
    if(await permission.isGranted){
      return true;
    }else{
      var result=await permission.request();
      if(result==permission.isGranted){
        return true;
      }else{
        return false;
      }
    }
  }

  Dio dio=Dio();
  double progress=0.0;
  Future<bool> saveFile(String url , String fileName)async{
    Directory? directory;
    try{
      if(Platform.isAndroid){
        if(await _requestPermission(Permission.storage)){
          directory=await getExternalStorageDirectory();
          String newPath="";
          List<String> path=directory!.path.split('/');
          for(int i=1;i<path.length;i++){
            if(path[i]!="Android"){
              newPath+="/"+path[i];
            }else{
              break;
            }
          }
          newPath="$newPath/FinancialAid";
          directory=Directory(newPath);
        }else{
          return false;
        }
      }else{
        if(await _requestPermission(Permission.photos)){
          directory=await getTemporaryDirectory();
        }else{
          return false;
        }
      }
      if(! await directory.exists()){
        await directory.create(recursive: true);
      }
      if(await directory.exists()){
        File saveFile=File(directory.path+"/$fileName");
        dio.download(url, saveFile.path,onReceiveProgress: (downloadSize,totalSize){
        });
        return true;
      }
    }catch(e){
      print(e.toString());
    }
    return false;
  }

  downloadFile(String url,String fileName)async{

    String path=await _getApplicationDirectory(fileName);

    await dio.download(
        url,
        path,
      onReceiveProgress: (receivedByte,totalByte){
          progress=receivedByte/totalByte;
      }
    );

  }


  Future<String> _getApplicationDirectory(String fileName)async{
    Directory? directory=await getExternalStorageDirectory();
    return "${directory!.path}/$fileName";
  }
}
