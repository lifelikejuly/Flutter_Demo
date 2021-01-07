import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutterannotation/mark.dart';



@WidgetMark()
class StatefulWidgetDemo extends StatefulWidget {
  @override
  _StatefulWidgetDemoState createState() => _StatefulWidgetDemoState();
}

class _StatefulWidgetDemoState extends State<StatefulWidgetDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("lll"),
          Text("kkkk"),
          Text("jojoj"),
        ],
      ),
    );
  }
}


@WidgetMark()
class StatelessWidgetDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("StatelessWidgetDemo lll"),
          Text("StatelessWidgetDemo kkkk"),
          Text("StatelessWidgetDemo jojoj"),
        ],
      ),
    );
  }
}
