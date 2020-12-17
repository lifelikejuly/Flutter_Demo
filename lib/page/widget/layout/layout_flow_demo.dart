import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as Vector;

class LayoutFlowDemo extends StatefulWidget {
  @override
  _LayoutFlowDemoState createState() => _LayoutFlowDemoState();
}

class _LayoutFlowDemoState extends State<LayoutFlowDemo> {
  @override
  Widget build(BuildContext context) {
    Widget flow =  Flow(
      delegate: _FlowDelegate(),
      children: [
        Container(
          color: Colors.cyan,
          width: 80,
          height: 50,
        ),
        Container(
          color: Colors.red,
          width: 150,
          height: 50,
        ),
        Container(
          color: Colors.yellow,
          width: 200,
          height: 50,
        ),
        Container(
          color: Colors.blue,
          width: 300,
          height: 50,
        ),
        Container(
          color: Colors.grey,
          width: 110,
          height: 50,
        ),
        Container(
          color: Colors.green,
          width: 180,
          height: 50,
        ),
      ],
    );
    return flow;
  }
}

class _FlowDelegate extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {
    var dx = 0.0;
    var dy = 0.0;
    for (int i = 0; i < context.childCount; i++) {
      if (dx + context.getChildSize(i).width > context.size.width) {
        dx = 0;
        dy += context.getChildSize(i).height;
      }
      context.paintChild(
        i,
        transform: Matrix4.compose(
          Vector.Vector3(dx, dy, 0),
          Vector.Quaternion(0, 0, 0, 0),
          Vector.Vector3(1, 1, 1),
        ),
      );
      dx += context.getChildSize(i).width;

//      if (dx + context.getChildSize(i).width < context.size.width) {
//        context.paintChild(
//          i,
//          transform: Matrix4.compose(
//            Vector.Vector3(dx, dy, 0),
//            Vector.Quaternion(0, 0, 0, 0),
//            Vector.Vector3(1, 1, 1),
//          ),
//        );
//        dx += context.getChildSize(i).width;
//      }

    }
  }

  @override
  Size getSize(BoxConstraints constraints) {
    //获取父容器约束条件确定Flow大小
    return super.getSize(constraints);
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return false;
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return super.getConstraintsForChild(i, constraints);
  }

  @override
  bool shouldRelayout(FlowDelegate oldDelegate) {
    return false;
  }
}
