import 'package:flutter/material.dart';
import 'package:flutter_demo/page/diy/circlelist/other/radialdrag_gesturedetector.dart';

import 'other/circle_3d_list.dart';
import 'dart:math';

class CircleListDemo extends StatefulWidget {
  @override
  State<CircleListDemo> createState() => _CircleListDemoState();
}

class _CircleListDemoState extends State<CircleListDemo> {
  // MyController myController;

  @override
  void initState() {
    super.initState();
    // myController = MyController();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: Colors.yellow,
    //   child: CircleList(
    //     origin: Offset(0, 0),
    //     children: List.generate(10, (index) {
    //       return ClipRRect(
    //           borderRadius: BorderRadius.all(Radius.circular(50)),
    //           child: Container(
    //               color: Colors.blue,
    //               width: 50,
    //               height: 50,
    //               child: Image.asset("images/${index + 1}.png")));
    //     }),
    //     onDragUpdate: (update) {
    //       Offset point = Offset(update.point.dx * 2, update.point.dy * 2);
    //       // myController.lookAt(point);
    //     },
    //   ),
    // );

    return Container(
      color: Colors.yellow,
      child: Circle3DList(
        initialAngle:  2 * pi / 4,
        // initialAngle: 1.2566370614359172,
        children: List.generate(5, (index) {
          return Container(
              // color: Colors.blue,
              alignment: Alignment.center,
              width: 244,
              height: 377,
              child: Image.asset("images/p${index + 1}.jpeg"));
        }),
        onDragUpdate: (update) {
          Offset point = Offset(update.point.dx * 2, update.point.dy * 2);

          // myController.lookAt(point);
        },
      ),
    );

  }


  Offset getChildPoint(
      int index, int length, double betweenRadius, double childrenDiameter) {
    double angel = 2 * pi * (index / length);
    double x = cos(angel) * betweenRadius - childrenDiameter / 2;
    double y = sin(angel) * betweenRadius - childrenDiameter / 2;

    return Offset(x, y);
  }

  Widget _cell(int index,double x,double y) {
    return Positioned(
      top: x,
      left: y,
      child: Container(
        color: Colors.blue,
        alignment: Alignment.center,
        width: 90,
        height: 90,
        child: Text(
          "$index",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
