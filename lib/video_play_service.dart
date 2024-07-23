import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

class VideoPlayService extends StatefulWidget{
  VideoPlayService({super.key,required this.file_path});

  String file_path;

  State<VideoPlayService> createState()=>_VideoPlayService();
}

class _VideoPlayService extends State<VideoPlayService>{
  VideoPlayerController? _controller;
  File? file;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    file=File(widget.file_path);
    _controller=VideoPlayerController.file(file!);
    // _controller!.initialize();
    // _controller!.play();
    _chewieController=ChewieController(videoPlayerController: _controller!,autoPlay: true,allowFullScreen: true,looping: true);
    print("${_controller!.value.aspectRatio}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(appBar: AppBar(title: Text(basename(widget.file_path)),),
      body: Chewie(controller: _chewieController!),
      );
    }
}