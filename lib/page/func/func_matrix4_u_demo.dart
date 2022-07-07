import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class FuncMatrix4UDemo extends StatefulWidget {
  @override
  State<FuncMatrix4UDemo> createState() => _FuncMatrix4DemoState();
}

class _FuncMatrix4DemoState extends State<FuncMatrix4UDemo> {
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
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      moveAngle += pi / 12;
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
    return Positioned(left: x, top: y, child: child);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Offset center = Offset(width / 2, height / 2);
    double length = min(center.dy, center.dx);

    print("<> build center $center length $length");

    List<Widget> list = List.empty(growable: true);
    list.add(
      Container(
        width: length,
        height:length,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: SizedBox(),
      ),
    );



    var cells = List.generate(5, (index) {
      double x = 0;
      double y = 0;
      // 每个点的角度
      double veryAngle = getAngle(index) + moveAngle;
      if(veryAngle > pi *2){
        veryAngle %= (pi *2);
      }
      // x 和 y坐标计算
      if (veryAngle >= 0 && veryAngle <= pi) {
        x = length * cos(veryAngle);
        y = length * sin(veryAngle);
      }else{
        // if(veryAngle <= pi * 3 / 2){
        //   x = -length + length * (veryAngle - pi) / (pi / 2);
        //   y = length * (veryAngle - pi) / (pi / 2);
        // }else{
        //   x = length * (veryAngle - pi *  3 /2) / (pi / 2);
        //   y = length - length * (veryAngle - pi  * 3 / 2) / (pi / 2);
        // }
      }
      print("<> build index $index veryAngle $veryAngle  pi $pi x $x y $y");
      return _cell(index, x+ length - 25, y+ length - 25);
    });
    list.addAll(cells);


    Widget child = Container(
      color: Colors.yellow,
      alignment: Alignment.center,
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: list,
      ),
    );

    return child;
  }

  double getAngle(int index) {
    double angle = 0;
    double specialAngle = pi / 4 + pi / 8;
    switch (index) {
      case 0:
        angle = pi * 7 / 4;
        break;
      case 1:
        angle = pi / 4 ;
        break;
      case 2:
        angle = pi / 2;
        break;
      case 3:
        angle = pi * 3 / 4;
        break;
      case 4:
        angle = pi  * 5 / 4;
        break;
    }
    return angle;
  }
}
