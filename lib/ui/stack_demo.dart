import 'package:flutter/material.dart';

class StackDemo extends StatefulWidget {
  @override
  _StackDemoState createState() => _StackDemoState();
}

class _StackDemoState extends State<StackDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.green,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              child: Text("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL"),
            )
          ],
        ),
      ),
    );
  }
}
