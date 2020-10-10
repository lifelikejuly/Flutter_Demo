import 'package:flutter/material.dart';

class GestureClickDemo extends StatefulWidget {
  @override
  _GestureClickDemoState createState() => _GestureClickDemoState();
}

class _GestureClickDemoState extends State<GestureClickDemo> {
  List<String> events = List();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: events.map((value) {
                  return Text(value);
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Text("Click"),
                    color: Colors.yellow,
                  ),
                  onTap: () {
                    _addEvent("onTap");
                  },
                  onTapDown: (downDetail) {
                    _addEvent("onTapDown");
                  },
                  onTapUp: (upDetail) {
                    _addEvent("onTapUp");
                  },
                  onTapCancel: () {
                    _addEvent("onTapCancel");
                  },
                  onSecondaryTapUp: (upDetail) {
                    _addEvent("onSecondaryTapUp");
                  },
                  onSecondaryTapDown: (downDetail) {
                    _addEvent("onSecondaryTapDown");
                  },
                  onSecondaryTapCancel: () {
                    _addEvent("onSecondaryTapCancel");
                  },
                  onDoubleTap: () {
                    _addEvent("onDoubleTap");
                  },
                ),
                GestureDetector(
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("KKKKKK"),
                          ),
                          onTap: () {},
                        ),
                        Text("AAAAAAA"),
                      ],
                    ),
                    color: Colors.yellow,
                  ),
                  onTap: () {
                    _addEvent("onTap");
                  },
                  onTapDown: (downDetail) {
                    _addEvent("onTapDown");
                  },
                  onTapUp: (upDetail) {
                    _addEvent("onTapUp");
                  },
                  onTapCancel: () {
                    _addEvent("onTapCancel");
                  },
                  onDoubleTap: () {
                    _addEvent("onDoubleTap");
                  },
                  onSecondaryTapUp: (upDetail) {
                    _addEvent("onSecondaryTapUp");
                  },
                  onSecondaryTapDown: (downDetail) {
                    _addEvent("onSecondaryTapDown");
                  },
                  onSecondaryTapCancel: () {
                    _addEvent("onSecondaryTapCancel");
                  },
                ),
                GestureDetector(
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.yellow,
                    child: Text("LongClick"),
                  ),
                  onLongPress: () {
                    _addEvent("onLongPress");
                  },
                  onLongPressStart: (longPressStartDetails) {
                    _addEvent("onLongPressStart");
                  },
                  onLongPressEnd: (longPressEnd) {
                    _addEvent("onLongPressEnd");
                  },
                  onLongPressMoveUpdate:
                      (LongPressMoveUpdateDetails longPressMoveUpdate) {
                    _addEvent("onLongPressMoveUpdate");
                  },
                  onLongPressUp: () {
                    _addEvent("onLongPressUp");
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _addEvent(String event) {
    if (event == "onLongPressMoveUpdate" &&
        events.contains("onLongPressMoveUpdate")) return;
    if (events.length > 20) {
      events.removeLast();
    }
    events.insert(0, event);
    setState(() {});
  }
}
