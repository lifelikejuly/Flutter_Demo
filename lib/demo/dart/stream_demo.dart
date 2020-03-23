import 'dart:async';

import 'package:flutter/material.dart';

class StreamDemo extends StatefulWidget {
  @override
  _StreamDemoState createState() => _StreamDemoState();
}

class _StreamDemoState extends State<StreamDemo> {
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

  _doStream7() {
    var counterStream =
        Stream<int>.periodic(Duration(seconds: 1), (x) => x).take(15);
    counterStream.forEach(print);
  }

  StreamController<int> numController;

  Stream<int> timedCounter(Duration interval, [int maxCount]) {
    var controller = StreamController<int>();
    int counter = 0;
    void tick(Timer timer) {
      counter++;
      controller.add(counter); // 请求 Stream 将计数器值作为事件发送。
      if (maxCount != null && counter >= maxCount) {
        timer.cancel();
        controller.close(); // 请求 Stream 关闭并告知监听器。
      }
    }

    Timer.periodic(interval, tick); // 缺点：在其拥有订阅者之前开始了。
    return controller.stream;
  }

  _doStream8() async {
    var counterStream = timedCounter(const Duration(seconds: 1), 5);
    // 5 秒后添加一个监听器。
    await for (int n in counterStream) {
      print(n); // 每秒打印输出一个整数，共打印 15 次。
    }
  }

  _doStream9() async {
    var counterStream = timedCounter(const Duration(seconds: 1), 5);
    await Future.delayed(const Duration(seconds: 5));
    // 5 秒后添加一个监听器。
    await for (int n in counterStream) {
      print(n); // 每秒打印输出一个整数，共打印 15 次。
    }
  }

  static const int a = 1;
  static final int b = 2;

  int num = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    numController?.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("test6"),
            onPressed: _doStream6,
          ),
          RaisedButton(
            child: Text("test7"),
            onPressed: _doStream7,
          ),
          RaisedButton(
            child: Text("test8"),
            onPressed: _doStream8,
          ),
          RaisedButton(
            child: Text("test9"),
            onPressed: _doStream9,
          ),
          RaisedButton(
            child: Text("createController"),
            onPressed: () {
              numController = StreamController<int>();
              for (var i = 0; i < 10; i++) {
                numController.add(i);
              }
              numController.onListen = () {
                print("numController onListen");
              };
              numController.onCancel = () {
                print("numController onCancel");
              };
              numController.onPause = () {
                print("numController onPause");
              };
              numController.onResume = () {
                print("numController onResume");
              };
            },
          ),
          RaisedButton(
            child: Text("ControllerAdd"),
            onPressed: () {
              if (!numController.isClosed) {
                numController.add(num);
                num++;
              }
            },
          ),
          RaisedButton(
            child: Text("print Controller"),
            onPressed: () async {
              await for (int n in numController.stream) {
                print("print numController $n"); // 每秒打印输出一个整数，共打印 15 次。
//                numController.close();
              }
            },
          )
        ],
      ),
    );
  }
}
