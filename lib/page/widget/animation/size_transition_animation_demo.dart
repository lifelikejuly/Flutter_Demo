import 'package:flutter/material.dart';

class SizeTransitionAnimationDemo extends StatefulWidget {
  @override
  State<SizeTransitionAnimationDemo> createState() =>
      _SizeTransitionAnimationDemoState();
}

class _SizeTransitionAnimationDemoState
    extends State<SizeTransitionAnimationDemo> with TickerProviderStateMixin {
  double height = 100;
  double width = 100;
  AnimationController _animationController;
  Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.value = 1.0;
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastLinearToSlowEaseIn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        GestureDetector(
          child: SizeTransition(
            sizeFactor: _animation,
            axis: Axis.horizontal,
            child: Container(
              color: Colors.blue,
              height: 100,
              width: 100,
              alignment: Alignment.center,
              child: Text("SizeTransition"),
            ),
          ),
          onTap: () {
            _animationController.forward(from: 0);
          },
        ),
        Container(
          color: Colors.yellow.withOpacity(0.5),
          height: 150,
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            child: AnimatedSize(
              duration: Duration(seconds: 2),
              child: Container(
                color: Colors.red,
                width: 100,
                height: height,
                alignment: Alignment.center,
                child: Container(
                  height: height,
                  width: 50,
                  color: Colors.yellow,
                  child: Text("AnimatedSize"),
                ),
              ),
            ),
            onTap: () {
              height = 150;
              width = 150;
              setState(() {});
            },
          ),
        )
      ],
    ));
  }
}
