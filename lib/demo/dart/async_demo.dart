import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class AsyncDemo extends StatefulWidget {
  @override
  _AsyncDemoState createState() => _AsyncDemoState();
}

class _AsyncDemoState extends State<AsyncDemo> {
  List<String> logs = List();

  _addLog(String value) {
    logs.add(value);
    setState(() {});
  }

  _removeLog() {
    logs.clear();
    setState(() {});
  }

  Stream<int> countStream(int to) async* {
    for (int i = 1; i <= to; i++) {
      yield i;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text("delayed"),
                    onPressed: () {
                      _removeLog();
                      Future.delayed(Duration(seconds: 1),
                          () => _addLog("Hello World async1"));
                      Future.delayed(Duration(seconds: 2),
                          () => _addLog("Hello World async2"));
                      _addLog("Hello World async3");
                      Future.value(200).then((value){
                        _addLog("Hello World value $value");
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text("await"),
                    onPressed: () async {
                      _removeLog();
                      _addLog("start");
                      String last =
                          await Future.delayed(Duration(seconds: 2), () {
//                        throw "throw error";
                        return 'Large Latte';
                      }).catchError((value) {
                        _addLog(value);
                      });
                      _addLog(last);
                      _addLog("end");
                    },
                  ),
                  RaisedButton(
                    child: Text("await try/catch"),
                    onPressed: () async {
                      _removeLog();
                      _addLog("start");
                      try {
                        String last =
                            await Future.delayed(Duration(seconds: 2), () {
                          throw "throw error";
                        }).whenComplete(() {
                          _addLog("whenComplete");
                        });
                        _addLog(last);
                      } catch (e) {
                        _addLog("catch $e");
                      }
                      _addLog("end");
                    },
                  ),
                  RaisedButton(
                    child: Text("then"),
                    onPressed: () {
                      _removeLog();
                      _addLog("start");
                      Future.delayed(Duration(seconds: 2), () => 'Large Latte')
                          .then((result) {
                        _addLog(result);
                      });
                      _addLog("end");
                    },
                  ),
                  RaisedButton(
                    child: Text("throw"),
                    onPressed: () {
                      _removeLog();
                      _addLog("start");
                      Future.delayed(Duration(seconds: 2), () {
                        throw "error";
                      }).then((result) {
                        _addLog(result);
                      }).catchError((error) {
                        _addLog(error);
                      });
                      _addLog("end");
                    },
                  ),
                  RaisedButton(
                    child: Text("value"),
                    onPressed: () {
                      _removeLog();
                      _addLog("value");
                      Future.value(true).then((value) {
                        _addLog(value.toString());
                      });
                      _addLog("value2");
                      _addLog("end");
                    },
                  ),
                  RaisedButton(
                    child: Text("error"),
                    onPressed: () {
                      _removeLog();
                      _addLog("error1");
                      Future.error("error").then((value) {
                        _addLog(value.toString());
                      });
                      _addLog("error2");
                      _addLog("end");
                    },
                  ),
                  RaisedButton(
                    child: Text("wait"),
                    onPressed: () {
                      _removeLog();
                      _addLog("wait start");
                      Future.wait([
                        Future.delayed(Duration(seconds: 1), () => 1),
                        Future.delayed(Duration(seconds: 2), () => 2),
                      ]).then((values) {
                        _addLog("values ${values[0]} ${values[1]}");
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text("Completer"),
                    onPressed: () {
                      _removeLog();
                      _addLog("Completer start");
                      final completer = new Completer<String>();
                      completer.future.then((value) {
                        _addLog(value);
                      });
                      completer.complete('Hello World');
                      _addLog("Completer end");
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: logs.map((value) {
                  return Text(value);
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
