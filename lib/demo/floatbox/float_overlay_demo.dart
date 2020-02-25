import 'package:flutter/material.dart';
import 'package:flutter_demo/demo/floatbox/app_float_box.dart';

class FloatOverLayDemo extends StatefulWidget {
  @override
  _FloatOverLayDemoState createState() => _FloatOverLayDemoState();
}

class _FloatOverLayDemoState extends State<FloatOverLayDemo> {
  static OverlayEntry entry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OverlayEntryDemo"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("add"),
            onPressed: () {
              entry?.remove();
              entry = null;
              entry = OverlayEntry(builder: (context) {
                return AppFloatBox();
              });
              Overlay.of(context).insert(entry);
            },
          ),
          RaisedButton(
            child: Text("delete"),
            onPressed: () {
              entry?.remove();
              entry = null;
            },
          ),
        ],
      ),
    );
  }
}
