import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

final String IMAGE_SRC =
    "http://pic37.nipic.com/20140113/8800276_184927469000_2.png";

class ClipAnimationDemo extends StatefulWidget {
  @override
  _ClipAnimationDemoState createState() => _ClipAnimationDemoState();
}

class _ClipAnimationDemoState extends State<ClipAnimationDemo>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  double _screenWidth;
  double _screenHeight;


  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _controller.forward();
            }
          });
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    _screenWidth = window.physicalSize.width;
    _screenHeight = window.physicalSize.height;
    _screenWidth = _screenWidth / window.devicePixelRatio;
    _screenHeight = _screenHeight / window.devicePixelRatio;

    print("<> _screenWidth $_screenWidth _screenHeight $_screenHeight");
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox renderBox = globalKey.currentContext.findRenderObject();
      print("<> ${renderBox.size.toString()}");

    });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.stop();
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRect(
          child: Image.network(
            IMAGE_SRC,
            fit: BoxFit.cover,
            key: globalKey,
          ),
        ),
        ClipRRect(
          child: Container(
            height: 100,
            width: 100,
            child: Image.network(
              IMAGE_SRC,
              fit: BoxFit.cover,
            ),
          ),
        ),
        AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ClipPath(
                clipper: TrianglePath(_animation.value, _screenWidth),
                child: Image.network(
                  IMAGE_SRC,
                  fit: BoxFit.cover,
                ),
              );
            }),
        AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()..scale(getScaleValue()),
                child: ClipPath(
                  clipper: TrianglePath(_animation.value, _screenWidth),
                  child: Image.network(
                    IMAGE_SRC,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
      ],
    );
  }

  double getScaleValue() {


    return 100 / 178.6 + _animation.value * (78.6/ 178.6);
  }
}

class TrianglePath extends CustomClipper<Path> {
  double scale;
  double width;

  TrianglePath(this.scale, this.width);

  @override
  Path getClip(Size size) {
    double addWidth = size.width / 4 * 3 + (size.width / 4) * scale;
    double reduceWidth1 = size.width / 4 - (size.width / 4) * scale;
    var path = Path();
    path.moveTo(reduceWidth1, 0); // 1
    path.lineTo(addWidth, 0); // 2
    path.lineTo(addWidth, size.height); // 3
    path.lineTo(reduceWidth1, size.height); // 4
    return path;
  }

  @override
  bool shouldReclip(TrianglePath oldClipper) {
    return oldClipper.scale != this.scale;
  }
}
