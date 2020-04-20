import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/part/fishredux/demopage1/page.dart';

class FishReduxDemo extends StatefulWidget {
  @override
  _FishReduxDemoState createState() => _FishReduxDemoState();
}

class _FishReduxDemoState extends State<FishReduxDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("FishPage1"),
              onPressed: () {
                Navigator.of(context).pushNamed('fishPage1');
              },
            ),
            RaisedButton(
              child: Text("FishPage2"),
              onPressed: () {
                Navigator.of(context).pushNamed('fishPage2');
              },
            )
          ],
        ),
      ),
    );
  }
}
