
import 'dart:io';

import 'package:flutter/material.dart';

import 'download_container.dart';
import 'download_controller.dart';

class DownloadDemo extends StatefulWidget {

  @override
  State<DownloadDemo> createState() => _DownloadDemoState();
}

class _DownloadDemoState extends State<DownloadDemo> {


  final String url = "https://img0.baidu.com/it/u=1896747624,1378601912&fm=253&fmt=auto&app=138&f=JPEG?w=640&h=417";

  DownloadController downloadController;


  @override
  void initState() {
    super.initState();

    downloadController = DownloadController(networkUrl: url);
  }


  @override
  Widget build(BuildContext context) {
    return  DownloadContainer(
      layoutBuilder: (context, filePath) {
        return Image.file(File(filePath));
      },
      errorChild: GestureDetector(
        child: Container(
            color: Colors.amber,
            width: 200,
            height: 300,
            child: Text("donwload fail click againe")),
        onTap: () {
          downloadController.load(suffix: "zip");
        },
      ),
      loadingBuilder: (context, child, event) {
        return Container(
          color: Colors.amber,
          width: 200,
          height: 300,
          child: Text(
              "is loading ${event.cumulativeBytesLoaded / event.expectedTotalBytes} "),
        );
      },
      initChild: GestureDetector(
        child: Container(
            color: Colors.amber,
            width: 200,
            height: 300,
            child: Text("click to start download")),
        onTap: () {
          downloadController.load();
        },
      ),
      downloadController: downloadController,
    );
  }
}
