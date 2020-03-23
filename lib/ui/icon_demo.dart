import 'package:flutter/material.dart';

class IconDemo extends StatefulWidget {
  @override
  _IconDemoState createState() => _IconDemoState();
}

class _IconDemoState extends State<IconDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "res/img/ic_star.png",
              width: 50,
            ),
            Image.asset(
              "res/img/ic_star.png",
              color: Colors.red,
              width: 50,
            ),
            Image.asset(
              "res/img/ic_star.png",
              color: Colors.yellow,
              width: 50,
            ),
            Image.asset(
              "res/img/ic_star.png",
              color: Colors.black,
              width: 50,
            ),
          ],
        ),
      ),
    );
  }
}
