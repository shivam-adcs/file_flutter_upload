import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileUploadService{ 
  static Future<dynamic> file_upload(File file)async{
    try{
      final fileupload= await FirebaseStorage.instance.ref().child(basename(file.path)).putFile(file);
      return true;
    }
    catch(e){
      print(e.toString());
    }
  }

  static Future<dynamic> file_download(String file_name)async{
    try{
      final Directory? app_document_directory=await getDownloadsDirectory();
      final String app_document_path=app_document_directory!.path;
      print("thisis the directory path: ${app_document_path}");
      final File downloaded_file=File(app_document_path+"/new_"+file_name); 

      final fileupload= await FirebaseStorage.instance.ref().child(file_name).writeToFile(downloaded_file);
      downloaded_file.create();
      await OpenFile.open(downloaded_file.path);
      print("FIle downloaded at ${downloaded_file.path}");

    }
    catch(e){
      print(e.toString());
    }
  }

  static Future<dynamic> get_All_File_Names()async{
    try{
      final result= await FirebaseStorage.instance.ref().listAll();
      return result.items;
    }
    catch(e){
      print(e.toString());
    }
  }
}