import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedBuilderDemo extends StatefulWidget {
  @override
  _AnimatedBuilderDemoState createState() => _AnimatedBuilderDemoState();
}

class _AnimatedBuilderDemoState extends State<AnimatedBuilderDemo>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            AnimatedBuilder(
              animation: _controller,
              child:
                  Container(width: 200.0, height: 200.0, color: Colors.green),
              builder: (BuildContext context, Widget child) {
                return Transform.rotate(
                  angle: _controller.value * 2.0 * pi,
                  child: child,
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Text("forward"),
                  onPressed: () {
                    _controller.forward();
                  },
                ),
                FlatButton(
                  child: Text("reverse"),
                  onPressed: () {
                    _controller.reverse();
                  },
                ),
              ],
            )
          ],
        ),
        color: Colors.grey,
      ),
    );
  }
}
