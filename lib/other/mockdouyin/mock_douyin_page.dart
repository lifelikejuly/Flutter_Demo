import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MockDouyinPage extends StatefulWidget {
  @override
  _MockDouyinPageState createState() => _MockDouyinPageState();
}

class _MockDouyinPageState extends State<MockDouyinPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              height: 120,
              width: screenWidth,
            ),
          ),
          Positioned(
            bottom: 0,
            width: 0.75 * screenWidth,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.redAccent
              ),
            ),
          ),
          Positioned(
            right: 0,
            width: 0.25 * screenWidth,
            height: 0.3 * screenHeight,
            top: 0.4 * screenHeight,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white
              ),
            ),
          )
        ],
      ),
    );
  }
}
