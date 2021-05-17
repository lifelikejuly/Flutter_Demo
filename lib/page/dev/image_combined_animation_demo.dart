import 'dart:ui';

import 'package:flutter/material.dart';

class ImageCombinedAnimationDemo extends StatefulWidget {
  @override
  _ImageCombinedAnimationDemoState createState() =>
      _ImageCombinedAnimationDemoState();
}

class _ImageCombinedAnimationDemoState extends State<ImageCombinedAnimationDemo>
    with SingleTickerProviderStateMixin {
  final String IMAGE_SRC =
      "http://pic37.nipic.com/20140113/8800276_184927469000_2.png";

  AnimationController _controller;
  Animation _animation;

  double _screenWidth;
  double _screenHeight;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this)
          ..addStatusListener((status) {
            // if (status == AnimationStatus.completed) {
            //   _controller.reverse();
            // } else if (status == AnimationStatus.dismissed) {
            //   _controller.forward();
            // }
          });
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    // _controller.forward();

    _screenWidth = window.physicalSize.width;
    _screenHeight = window.physicalSize.height;
    _screenWidth = _screenWidth / window.devicePixelRatio;
    _screenHeight = _screenHeight / window.devicePixelRatio;

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
      children: <Widget>[
        Image.network(
          IMAGE_SRC,
          fit: BoxFit.cover,
        ),
        AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..scale(getScaleValue())
                  ..translate(
                      0.0, _animation.value * (_screenHeight - 178.6) / 2.0),
                child: ClipPath(
                  clipper: TrianglePath(_animation.value, _screenWidth),
                  child: GestureDetector(
                    child: Image.network(
                      IMAGE_SRC,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      print("<> _controller.value ${_controller.value}");
                      if (_controller.value == 0) {
                        _controller.forward();
                      } else {
                        _controller.reverse();
                      }
                    },
                  ),
                ),
              );
            }),
        FlatButton(
          child: Text("+"),
          onPressed: () {
            _controller.forward();
          },
        ),
        FlatButton(
          child: Text("-"),
          onPressed: () {
            _controller.reverse();
          },
        ),
      ],
    );
  }

  double getScaleValue() {
    return 100 / 178.6 + _animation.value * (78.6 / 178.6);
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
