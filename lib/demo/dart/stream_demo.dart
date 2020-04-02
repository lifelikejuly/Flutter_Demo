import 'dart:async';

import 'package:flutter/material.dart';

class StreamDemo extends StatefulWidget {
  @override
  _StreamDemoState createState() => _StreamDemoState();
}

class _StreamDemoState extends State<StreamDemo> {
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  StreamSubscription<int> subscription;
  StreamSubscription<int> subscriptionListen;
  Stream<int> stream;
  NumberCreator numberCreator;

  int value = 10;
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
                    child: Text("Stream"),
                    onPressed: () {
                      _removeLog();
                      countStream(10).listen(
                        (data) => _addLog("Stream $data"),
                      );
                    },
                  ),
                  RaisedButton(
                    child: Text("Stream Error"),
                    onPressed: () {
                      _removeLog();
                      subscription = countStream(10).listen((data) {
                        _addLog("Stream $data");
                        throw "Error";
                      }, onDone: () {
                        _addLog("Stream Done");
                      }, onError: () {
                        _addLog("Stream onError");
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text("BroadcastStream"),
                    onPressed: () {
                      _removeLog();
                      final stream = countStream(10).asBroadcastStream();
                      stream.listen(
                        (data) => _addLog("Stream1 $data"),
                      );
                      stream.listen(
                        (data) => _addLog("Stream2 $data"),
                      );
                    },
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                          child: Text("createStream"),
                          onPressed: () {
                            _removeLog();
                            stream = countStream(10);
                          },
                        ),
                        RaisedButton(
                          child: Text("listen"),
                          onPressed: () {
                            subscriptionListen = stream.listen((value) {
                              _addLog("ListenStream $value");
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                          child: Text("createStreamController"),
                          onPressed: () {
                            _removeLog();
                            numberCreator = NumberCreator();
                          },
                        ),
                        RaisedButton(
                          child: Text("setValue"),
                          onPressed: () {
                            if (numberCreator != null) {
                              value++;
                              numberCreator._controller.add(value);
                            }
                          },
                        ),
                        RaisedButton(
                          child: Text("Listen"),
                          onPressed: () {
                            subscriptionListen =
                                numberCreator.stream.listen((value) {
                              _addLog("ListenStreamController $value");
                            });
                          },
                        ),
                        RaisedButton(
                          child: Text("pause"),
                          onPressed: () {
                            if (subscriptionListen != null) {
                              subscriptionListen.pause();
                            }
                          },
                        ),
                        RaisedButton(
                          child: Text("resume"),
                          onPressed: () {
                            if (subscriptionListen != null) {
                              subscriptionListen.resume();
                            }
                          },
                        ),
                        RaisedButton(
                          child: Text("cancel"),
                          onPressed: () {
                            _removeLog();
                            if (subscriptionListen != null) {
                              subscriptionListen.cancel();
                            }
                            if (numberCreator != null) {
//                              numberCreator.stream.listen(onData)
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      StreamBuilder<int>(
                        builder: (context, data) {
                          return Text(data.data.toString());
                        },
                        initialData: 10000,
                        stream: numberCreator?.stream,
                      ),
                    ],
                  )
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

class NumberCreator {
  NumberCreator() {
    for (int i = 0; i < 10; i++) {
      _controller.sink.add(_count);
      _count++;
    }
  }

  var _count = 1;
  StreamController<int> _controller = StreamController<int>();

  Stream<int> get stream => _controller.stream;
}
