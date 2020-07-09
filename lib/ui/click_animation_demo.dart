import 'package:flutter/material.dart';

class ClickAnimationDemo extends StatefulWidget {
  @override
  _ClickAnimationDemoState createState() => _ClickAnimationDemoState();
}

class _ClickAnimationDemoState extends State<ClickAnimationDemo>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  AnimationStatusListener listener;

  @override
  void initState() {
    super.initState();
    listener = (status) {
      if (status == AnimationStatus.completed) {
        _animationController.removeStatusListener(listener);
        _animationController.animateTo(
          1.0,
          duration: Duration(milliseconds: 200),
          curve: Curves.linear,
        );
      }
    };
    _animationController = AnimationController(
        value: 1.0,
        upperBound: 1.0,
        lowerBound: 0.9,
        vsync: this,
        duration: Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          ScaleTransition(
            scale: _animationController,
            alignment: Alignment.center,
            child: GestureDetector(
              onLongPress: () {
                _animationController.addStatusListener(listener);
                _animationController.animateTo(0.9,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear);
              },
              child: Container(
                height: 100,
                width: 100,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}
