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
  _test() async {
    Future.delayed(Duration(seconds: 1), () => print("Hello World async1"));
    Future.delayed(Duration(seconds: 2), () => print("Hello World async2"));
    print("Hello World async3");
  }

  _doAsync() {
    _test();
  }

  Future<String> _test2() async {
    return Future.delayed(Duration(seconds: 2), () => 'Large Latte');
  }

  Future<String> _test3(value) async {
    return Future.delayed(Duration(seconds: 2), () => '$value + Large Latte');
  }

  _doAsync2() async {
    Future.delayed(Duration(seconds: 1), () => print("Hello World before"));
    Future.delayed(Duration(seconds: 2), () => print("Hello World seconds 2"));
    String rest = await _test2();
    print("Hello World $rest");
    Future.delayed(Duration(seconds: 1), () => print("Hello World after"));
  }

  _doAsync3() {
    _test2().then((value) {
      print("_test2 result: $value");
      _test3(value).then((value) {
        print("_doAsync3 result: $value");
      }).catchError((error) {
        error.toString();
      });
    }).catchError((error) {
      error.toString();
    });
  }

  _doAsync4() async {
    String result2 = await _test2();
    print("_test2 result: $result2");
    String result = await _test3(result2);
    print("_doAsync4 result: $result");
  }

  Future<String> _test5(value) async {
    return Future.delayed(
        Duration(seconds: 2), () => throw "throw Error HAHAHA");
  }

  _doAsync5() async {
    try {
      String result2 = await _test2();
      print("_test2 result: $result2");
      String result = await _test5(result2);
      print("_doAsync5 result: $result");
    } catch (e) {
      print("catch ${e.toString()}");
    }
  }

  _doAsync6() async {
    int nowTime = DateTime.now().millisecondsSinceEpoch;
    Future.wait([
      Future.delayed(Duration(seconds: 2), () => "2"),
      Future.delayed(Duration(seconds: 4), () => "4"),
    ]).then((reslut) {
      print(
          "${reslut[0]}-${reslut[1]} use ${DateTime.now().millisecondsSinceEpoch - nowTime}");
    });
    nowTime = DateTime.now().millisecondsSinceEpoch;
    String text1 = await Future.delayed(Duration(seconds: 2), () => "2");
    String text2 = await Future.delayed(Duration(seconds: 4), () => "4");
    print(
        "$text1-$text2 use ${DateTime.now().millisecondsSinceEpoch - nowTime}");

    Future.any([
      Future.delayed(Duration(seconds: 1), () => "1"),
      Future.delayed(Duration(seconds: 2), () => "2"),
      Future.delayed(Duration(seconds: 3), () => "3"),
      Future.delayed(Duration(seconds: 4), () => "4"),
    ]).then((reslut) {
      print(
          "$reslut use ${DateTime.now().millisecondsSinceEpoch - nowTime}");
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("test1"),
            onPressed: _doAsync,
          ),
          RaisedButton(
            child: Text("test2"),
            onPressed: _doAsync2,
          ),
          RaisedButton(
            child: Text("test3"),
            onPressed: _doAsync3,
          ),
          RaisedButton(
            child: Text("test4"),
            onPressed: _doAsync4,
          ),
          RaisedButton(
            child: Text("test5"),
            onPressed: _doAsync5,
          ),
          RaisedButton(
            child: Text("test6"),
            onPressed: _doAsync6,
          ),
          RaisedButton(
            child: Text("test7"),
            onPressed: (){
              Future.value(Future<int>.sync(() => 10));
            },
          ),
        ],
      ),
    );
  }
}
