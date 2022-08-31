
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FuncFilePathDemo extends StatefulWidget {

  @override
  State<FuncFilePathDemo> createState() => _FuncFilePathDemoState();
}

class _FuncFilePathDemoState extends State<FuncFilePathDemo> {


  Directory externalDirectory;
  List<Directory> externalCacheDirectories;
  Directory applicationSupportDirectory;
  Directory applicationDocumentDirectory;
  Directory temporaryDirectory;

  @override
  void initState() {
    super.initState();

    _findFilePath();
  }

  _findFilePath() async{
    externalDirectory = await getExternalStorageDirectory();
    externalCacheDirectories = await getExternalCacheDirectories();
    applicationSupportDirectory = await getApplicationSupportDirectory();
    applicationDocumentDirectory = await getApplicationDocumentsDirectory();
    temporaryDirectory = await getTemporaryDirectory();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("${externalDirectory?.path}"),
          SizedBox(height: 50,),
          Text("${externalCacheDirectories}"),
          SizedBox(height: 50,),
          Text("${applicationSupportDirectory?.path}"),
          SizedBox(height: 50,),
          Text("${applicationDocumentDirectory?.path}"),
          SizedBox(height: 50,),
          Text("${temporaryDirectory?.path}"),
        ],
      ),
    );
  }
}
