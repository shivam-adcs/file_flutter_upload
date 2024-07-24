import 'dart:collection';
import 'dart:io';

import 'package:file_flutter_upload/file_upload_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:path/path.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
  bool is_uploading=false;
  double upload_value=0;
  Future<dynamic> get_all_file_names()async{
     files_names=await FileUploadService.get_All_File_Names();
     setState(() {
       files_names=files_names;
     });
  }

  bool isloading=false;

  Future display_dialog(String message){
    return showDialog(context: this.context, builder: (BuildContext context){
      return SimpleDialog(children: <Widget>[
        Container(width:200,height: 200,child: Column(mainAxisAlignment:MainAxisAlignment.center,children:<Widget>[
            CircularProgressIndicator(),
            Text("$message"),
        ] 
          )),
          
      ],);
    });
  }
  Future open_file(int index)async{
    display_dialog("Opening...");
     await FileUploadService.file_download(files_names[index].fullPath,this.context);
     Navigator.pop(this.context);
  }

  Future upload_file()async{
        FilePickerResult? file=await FilePicker.platform.pickFiles();
              if(file!=null){
                final file1= File(file.files.single.path!);
                _file=file1;
                final storageReference=await FileUploadService.file_upload(_file!,this.context);
                try{
                  final UploadTask uploadTask= storageReference.putFile(_file);
                  setState(() {
                      is_uploading=true;
                  });
                uploadTask.snapshotEvents.listen(onDone: ()async{
                  setState(() {
                    is_uploading=false;
                      display_dialog("\nUploaded files!!!\n Now Opening");
                  });
                  final result=await FileUploadService.file_download(basename(_file!.path),this.context);
                  Navigator.pop(this.context);
                },(TaskSnapshot snapshot)async{
                setState((){
                  upload_value=(snapshot.bytesTransferred/snapshot.totalBytes)*100;
                });
                if(upload_value==100){
                    
                  }
              });
                     
              
                
                await  get_all_file_names();
                setState(() {
                  
                });
              
                }
                catch(e){
                  print(e.toString());
                }
                
              }
              else{
                print("file is not selected");
                // Navigator.of(this.context).pop();
              }
              
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
              

              is_uploading?Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Text("Uploading :",style: TextStyle(color: Colors.green[600]),),
                    Text("${basename(_file!.path)}",style: TextStyle(),)
                    ]),
                  LinearPercentIndicator(
                    lineHeight: 20.0,
                    curve: Curves.easeIn,
                    barRadius: Radius.circular(1.0),
                    percent: (upload_value*0.01),
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                    center: Text("${upload_value.toString()}%",style:TextStyle(fontSize: 14)),
                  ),
                ],
              ):Container(),
              files_names.length>0?
              ListView.builder(physics: NeverScrollableScrollPhysics(),shrinkWrap:true,itemCount: files_names.length,itemBuilder: (context,index){
                return ListTile(title: Text(files_names[index].fullPath),onTap: ()=>open_file(index),);
              }):Text("loading"),
              
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: upload_file,child: Icon(CupertinoIcons.add),),
    );
  }
}
