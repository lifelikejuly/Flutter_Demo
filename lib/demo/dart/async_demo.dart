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

  Future<int> sumStream(Stream<int> stream) async {
    var sum = 0;
    await for (var value in stream) {
      sum += value;
    }
    return sum;
  }

  Stream<int> countStream(int to) async* {
    for (int i = 1; i <= to; i++) {
      yield i;
    }
  }

  _doStream6() async {
    var stream = countStream(10);
    var sum = await sumStream(stream);
    print(sum); // 55
  }

  Stream<int> foo2() async* {
    print('foo2 start');
    for (int i = 0; i < 3; i++) {
      print('运行了foo2，当前index：${i}');
      yield i;
    }
    print('foo2 stop');
  }

//  _doStream7() {
//    var b = foo2().;
//    print('还没开始调用 moveNext');
//    b.moveNext();
//    print('第${b.current}次moveNext');
//    b.moveNext();
//    print('第${b.current}次moveNext');
//    b.moveNext();
//    print('第${b.current}次moveNext');
//  }

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
            onPressed: _doStream6,
          ),
//          RaisedButton(
//            child: Text("test7"),
//            onPressed: _doStream7,
//          )
        ],
      ),
    );
  }
}
