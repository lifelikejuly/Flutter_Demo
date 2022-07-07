import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class FuncMatrix4PentagonDemo extends StatefulWidget {
  @override
  State<FuncMatrix4PentagonDemo> createState() => _FuncMatrix4DemoState();
}

class _FuncMatrix4DemoState extends State<FuncMatrix4PentagonDemo> {
  Matrix4 matrix4 = Matrix4.identity();

  Timer timer;

  double moveAngle = 0;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    matrix4 = Matrix4.zero();
    timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      moveAngle += pi / 8;
      setState(() {});
    });
  }

  Widget _cell(int index, double x, double y) {

    Widget child = Container(
      alignment: Alignment.center,
      width: 50,
      height: 50,
      color: Colors.blue,
      child: Text(
        "$index",
        style: TextStyle(color: Colors.white),
      ),
    );
    // child = Transform(
    //   transform: Matrix4.identity()..rotateX( -pi * 3/ 4),
    //   child: child,
    // );
    return Positioned(
        left: x,
        top: y,
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Offset center = Offset(width / 2, height / 2);
    double length = min(center.dy, center.dx);

    Widget child = Container(
      color: Colors.yellow,
      alignment: Alignment.center,
      child: Stack(
        children: List.generate(5, (index) {
          double angle = 1.0;
          double x;
          double y;

          // 每个点的角度
          double veryAngle = 2 * pi / 5 * index + pi / 2;

          x = length * cos(veryAngle + moveAngle);
          y = length * sin(veryAngle + moveAngle);

          print("<> index $index x $x y $y");
          return _cell(index, x + length - 25, y + length - 25);
        }),
      ),
    );

    // child = Transform(
    //   transform: Matrix4.identity()..rotateX(pi / 4),
    //   child: child,
    // );

    return child;
  }
}


// switch (index) {
//   case 4:
//     x = length * cos(angle * pi / 10 + moveAngle);
//     y = length * sin(angle * pi / 10 + moveAngle);
//     break;
//   case 0:
//     x = 0 * cos(angle * pi / 2 + moveAngle);
//     y = length * sin(angle * pi / 2 + moveAngle);
//     break;
//   case 1:
//     x = -length * cos(angle * pi / 10 - moveAngle);
//     y = length * sin(angle * pi / 10 - moveAngle);
//     break;
//   case 2:
//     x = -length * sin(angle * pi / 5 - moveAngle);
//     y = -length * cos(angle * pi / 5 - moveAngle);
//     break;
//   case 3:
//     x = length * sin(angle * pi / 5 + moveAngle);
//     y = -length * cos(angle * pi / 5 + moveAngle);
//     break;
// }
