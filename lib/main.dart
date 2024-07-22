import 'dart:collection';
import 'dart:io';

import 'package:file_flutter_upload/file_upload_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File? _file;
  var files_names=[];

  Future<dynamic> get_all_file_names()async{
     files_names=await FileUploadService.get_All_File_Names();
     setState(() {
       files_names=files_names;
     });
  }




  @override
  void initState() {
    super.initState();
    get_all_file_names();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("File Upload Firebase"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              files_names.length>0?
              ListView.builder(shrinkWrap:true,itemCount: files_names.length,itemBuilder: (context,index){
                return ListTile(title: Text(files_names[index].fullPath),onTap: ()async{
                  print(files_names[index].fullPath);
                  await FileUploadService.file_download(files_names[index].fullPath);
                  },);
              }):Text("loading"),
              
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()async{
        FilePickerResult? file=await FilePicker.platform.pickFiles();
              if(file!=null){
                final file1= File(file.files.single.path!);
                _file=file1;
                print(basename(_file!.path));

                if(await FileUploadService.file_upload(_file!)){
                  print("Files_uploaded");
                  await FileUploadService.file_download(basename(_file!.path));
                }
                else{
                  print("Files not uploaded");
                }
                await  get_all_file_names();
                setState(() {
                  
                });
              }
      },child: Icon(CupertinoIcons.add),),
    );
  }
}
