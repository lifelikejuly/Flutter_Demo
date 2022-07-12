import 'dart:math';

import 'package:flutter/material.dart';

class FuncMatrix4Demo extends StatefulWidget {
  @override
  State<FuncMatrix4Demo> createState() => _FuncMatrix4DemoState();
}

class _FuncMatrix4DemoState extends State<FuncMatrix4Demo> {
  Matrix4 matrix4 = Matrix4.identity();


  @override
  void initState() {
    super.initState();
    matrix4 = Matrix4.zero();
    // matrix4 = Matrix4.identity();
    // matrix4.scale(0.5);
    // matrix4.rotateX(pi / 4);
    // matrix4.rotateY(pi / 4);
    // matrix4.rotateZ(pi / 4);


    // matrix4 = Matrix4.translationValues(
    //   20,
    //   20,
    //   0,
    // )..scale(0.5);

    double radius = 100;
    double angle = pi *   2 / 4;
    double x =  cos(angle) * radius;
    double y =  sin(angle) * radius;

    // matrix4 = Matrix4.translationValues(
    //   x,
    //   y,
    //   0,
    // );

    matrix4 = Matrix4.translationValues(
      100,
      200,
      0,
    );

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.grey,
      // alignment: Alignment.center,
      child: Stack(
        children: [
          Transform(
            transform: matrix4,
            child: Image.network(
              "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.jj20.com%2Fup%2Fallimg%2Ftp02%2F1Z9191923035R0-0-lp.jpg&refer=http%3A%2F%2Fimg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1659616587&t=833f1012345f22731529e1040c51add0",
              width: 150,
              height: 150,
              fit: BoxFit.fill,
            ),
          ),
          Transform(
            transform: matrix4.scaled(0.5),
            child: Image.network(
              "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.jj20.com%2Fup%2Fallimg%2Ftp02%2F1Z9191923035R0-0-lp.jpg&refer=http%3A%2F%2Fimg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1659616587&t=833f1012345f22731529e1040c51add0",
              width: 150,
              height: 150,
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }
}
