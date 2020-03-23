import 'dart:async';

import 'package:flutter/material.dart';

class TimerDemo extends StatefulWidget {
  @override
  _TimerDemoState createState() => _TimerDemoState();
}

class _TimerDemoState extends State<TimerDemo> {
  Timer _timer;
  String log = "";

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      log = "TimerDemo periodic tick:${timer.tick} isActive:${timer.isActive}";
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("stop timer"),
            onPressed: () {
              _timer?.cancel();
              log =
                  "TimerDemo periodic tick:${_timer?.tick} isActive:${_timer?.isActive}";
              setState(() {});
            },
          ),
          RaisedButton(
            child: Text("start timer"),
            onPressed: () {
              _timer?.cancel();
              _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
                log =
                    "TimerDemo periodic tick:${timer.tick} isActive:${timer.isActive}";
                setState(() {});
              });
            },
          ),
          RaisedButton(
            child: Text("start timer"),
            onPressed: (){
            },
          ),
          Text(log)
        ],
      ),
    );
  }
}
