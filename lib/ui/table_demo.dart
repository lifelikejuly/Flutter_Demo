import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TableDemo extends StatefulWidget {
  @override
  _TableDemoState createState() => _TableDemoState();
}

class _TableDemoState extends State<TableDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Table(
            textBaseline: TextBaseline.alphabetic,
            textDirection: TextDirection.rtl,
            border: TableBorder.all(color: Colors.black),
            children: [
              TableRow(children: [
                Text("111"),
                Text("111"),
                Text("111"),
                Text("111"),
              ]),
              TableRow(children: [
                Text("222"),
                Text("222"),
                Text("222"),
                Text("222"),
              ]),
              TableRow(children: [
                Text("333"),
                Text("333"),
                Text("333"),
                Text("333"),
              ])
            ],
          ),
        ],
      ),
    );
  }
}
