import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';

class PdfviewService extends StatefulWidget{
  PdfviewService({super.key,required String this.file_path});
  String file_path;

State<PdfviewService> createState()=> _PDFViewService();
}

class _PDFViewService extends State<PdfviewService>{


late PDFViewController _pdfViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("${widget.file_path}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
  }

  @override
  void dispose() {
    super.dispose();
  }

  int current_page=0;
  int total_page=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(title: Text(basename(widget.file_path)),),
          body: SafeArea(child: PDFView(
            filePath: widget.file_path,
            autoSpacing: true,
            swipeHorizontal: false,
            enableSwipe: true,
            pageSnap: true,
            onError: (error){print(error.toString());},
            onPageError: (page,error){print(error.toString());},
            onViewCreated: (PDFViewController vc){
              _pdfViewController=vc;
            },
            onPageChanged: (int? page, int? total){
              setState(() {
                current_page=page!;
                total_page=total!;
              });
              print("Page changed");
            },
          ),),
    );
  }
}
