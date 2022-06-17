

import 'package:flutter/material.dart';

class LayoutWrapDemo extends StatefulWidget {

  @override
  State<LayoutWrapDemo> createState() => _LayoutWrapDemoState();
}

class _LayoutWrapDemoState extends State<LayoutWrapDemo> {
  @override
  Widget build(BuildContext context) {
    Widget wrap =  Wrap(
      direction: Axis.horizontal,
      children: [
        Container(
          color: Colors.cyan,
          width: 80,
          height: 50,
        ),
        Container(
          color: Colors.red,
          width: 150,
          height: 50,
        ),
        Container(
          color: Colors.yellow,
          width: 200,
          height: 50,
        ),
        Container(
          color: Colors.blue,
          width: 300,
          height: 50,
        ),
        Container(
          color: Colors.grey,
          width: 110,
          height: 50,
        ),
        Container(
          color: Colors.green,
          width: 180,
          height: 50,
        ),
      ],
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: wrap,
    );
  }
}
