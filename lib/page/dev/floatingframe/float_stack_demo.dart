import 'package:flutter/material.dart';

import 'app_float_box.dart';

class FloatStackDemo extends StatefulWidget {
  @override
  _FloatStackDemoState createState() => _FloatStackDemoState();
}

class _FloatStackDemoState extends State<FloatStackDemo> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        AppFloatBox(),
      ],
    );
  }
}
