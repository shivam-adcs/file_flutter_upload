import 'dart:async';
import 'dart:io';

import 'package:file_flutter_upload/image_service.dart';
import 'package:file_flutter_upload/pdfview_service.dart';
import 'package:file_flutter_upload/video_play_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class FileUploadService{ 
  static Future<dynamic> file_upload(File file,BuildContext context)async{
    try{

      final Reference storageReference=FirebaseStorage.instance.ref().child(basename(file.path));
      return storageReference;
      
      return true;
    }
    catch(e){
      print(e.toString());
    }
  }

  static Future<dynamic> file_download(String file_name,BuildContext context)async{
    try{
      final Directory? app_document_directory=await getDownloadsDirectory();
      final String app_document_path=app_document_directory!.path;
      print("thisis the directory path: ${app_document_path}");
      final File downloaded_file=File(app_document_path+"/new_"+file_name); 

      final fileupload= await FirebaseStorage.instance.ref().child(file_name).writeToFile(downloaded_file);
      downloaded_file.create();
      final file_type=lookupMimeType(file_name);
      print(file_type);

      if(file_type=="application/pdf"){
        final file_path="$app_document_path/new_$file_name";
        final is_completed=await Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfviewService(file_path: file_path)));
        // Navigator.pop(context);
      }
      else if(file_type=="video/mp4"){
        final file_path="$app_document_path/new_$file_name";
        final is_completed=await Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoPlayService(file_path: file_path)));
        // Navigator.pop(context);
      }
      else if(file_type!.contains("image")){
        final file_path="$app_document_path/new_$file_name";
        final is_completed=await Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageService(file_path: file_path)));
        // Navigator.pop(context);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Unable to open this file in this app select external application to continue")));
        Timer(Duration(seconds: 2),()async {
          await OpenFile.open(downloaded_file.path);
          print("FIle downloaded at ${downloaded_file.path}");
        });
      }
      return true;

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