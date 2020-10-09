import 'package:flutter/material.dart';
import 'package:flutter_demo/demo/flip/flip_num_text.dart';

class FlipDemo extends StatefulWidget {
  @override
  _FlipDemoState createState() => _FlipDemoState();
}

class _FlipDemoState extends State<FlipDemo> {
  int num = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          FlipNumText(num, 59),
          RaisedButton(
            child: Text("ADD"),
            onPressed: () {
              setState(() {
                if (num < 60) {
                  num += 1;
                } else {
                  num = 0;
                }
              });
            },
          )
        ],
      ),
    );
  }
}
