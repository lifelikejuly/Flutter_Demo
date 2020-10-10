import 'package:flutter/material.dart';

import 'app_float_box.dart';

class FloatOverLayDemo extends StatefulWidget {
  @override
  _FloatOverLayDemoState createState() => _FloatOverLayDemoState();
}

class _FloatOverLayDemoState extends State<FloatOverLayDemo> {
  static OverlayEntry entry;

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
