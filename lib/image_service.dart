import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:photo_view/photo_view.dart';

class ImageService extends StatefulWidget{

  ImageService({super.key,required this.file_path});
  String file_path;
  State<ImageService> createState()=>_ImageService();
}

class _ImageService extends State<ImageService>{

  File? file;

  @override
  void initState() {
    super.initState();
    file=File(widget.file_path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(basename(widget.file_path)),),
      body:Container(child: PhotoView(imageProvider: FileImage(file!)),)
    );
  }
}