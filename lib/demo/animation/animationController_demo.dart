import 'package:flutter/material.dart';

class AnimationControllerDemo extends StatefulWidget {
  @override
  _AnimationControllerDemoState createState() =>
      _AnimationControllerDemoState();
}

class _AnimationControllerDemoState extends State<AnimationControllerDemo>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      animationBehavior: AnimationBehavior.preserve,
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(seconds: 2),
    );
    _animationController.addListener(() {
      //每次动画执行回调接口
      _animationController.value;
      setState(() {});
      print("AnimationControllerDemo ${_animationController.value}");
    });
    _animationController.addStatusListener((status) {
      //动画状态变化回调接口
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 10,
              left: 10 + _animationController.value * 100,
              child: Text("KKKKK"),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: RaisedButton(
                child: Text("forward"),
                onPressed: () {
                  _animationController.forward();
                },
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: RaisedButton(
                child: Text("reverse"),
                onPressed: () {
                  _animationController.reverse();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
