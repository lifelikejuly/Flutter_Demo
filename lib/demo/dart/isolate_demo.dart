import 'dart:isolate';

import 'package:flutter/material.dart';

class IsolateDemo extends StatefulWidget {
  @override
  _IsolateDemoState createState() => _IsolateDemoState();
}

class _IsolateDemoState extends State<IsolateDemo> {
  ReceivePort receivePort;

  @override
  void initState() {
    super.initState();
    simple1();
  }

  simple1() {
    Isolate.spawn(test1, "hello");
  }

  test1(string) {
    print("test1 $string");
  }

  todo() async {
    // 1.创建管道
    receivePort = ReceivePort();
    // 2.创建新的Isolate
    Isolate isolate = await Isolate.spawn<SendPort>(fuc, receivePort.sendPort);
    // 3.监听管道消息
    receivePort.listen((data) {
      print('Data：$data');
      // 不再使用时，我们会关闭管道
      receivePort.close();
      // 需要将isolate杀死
      isolate?.kill(priority: Isolate.immediate);
    });
  }

  static fuc(SendPort sendPort) {
    sendPort.send("Hello World");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          FlatButton(
            child: Text("sss"),
            onPressed: () {

            },
          )
        ],
      ),
    );
  }
}
