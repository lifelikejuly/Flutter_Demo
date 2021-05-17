import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StreamDemo extends StatefulWidget {
  @override
  _StreamDemoState createState() => _StreamDemoState();
}

class _StreamDemoState extends State<StreamDemo> {
  StreamController<int> _streamMoreController;
  Stream<int> _moreStream;

  StreamController<int> _streamOneController;
  Stream<int> _oneStream;


  int count = 0;
  @override
  void initState() {
    super.initState();
    _streamMoreController = StreamController.broadcast();
    _moreStream = _streamMoreController.stream;
    _streamMoreController.add(0);

    _streamOneController = StreamController();
    _oneStream = _streamOneController.stream;
    _streamOneController.add(0);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          StreamBuilder(
            stream: _oneStream,
            builder: (context, data) {
              return Text("_oneStream ${data.data}");
            },
          ),
          StreamBuilder(
            stream: _moreStream,
            builder: (context, data) {
              return Text("_moreStream ${data.data}");
            },
          ),
          StreamBuilder(
            stream: _moreStream,
            builder: (context, data) {
              return Text("_moreStream ${data.data}");
            },
          ),
          FlatButton(
            child: Text("_moreStream +"),
            onPressed: (){
              _streamMoreController.add(count++);
            },
          ),
          FlatButton(
            child: Text("_oneStream +"),
            onPressed: (){
              _streamOneController.add(count++);
            },
          )
        ],
      ),
    );
  }
}
