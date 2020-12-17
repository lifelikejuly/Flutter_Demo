import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/diy_wrap.dart';
import 'package:vector_math/vector_math_64.dart' as Vector;

class OneLineWrapDemo extends StatefulWidget {
  @override
  _OneLineWrapDemoState createState() => _OneLineWrapDemoState();
}

class _OneLineWrapDemoState extends State<OneLineWrapDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        children: <Widget>[
          /// 自定义并不好处理超出一行的情况
          Expanded(
            child: DIYWrap(
              children: _list(),
            ),
          ),
          /// 使用Flow其实就能很好自定义显示
          Expanded(
              child: Flow(
                delegate: _FlowDelegate(),
                children: _list(),
              ),
          )
        ],
      ),
    );
  }

  List<Widget> _list(){
    return [
      Text("11111111111111111",style: TextStyle(fontSize: 20),),
      Text("222222"),
      Text("333333"),
      Text("4444444"),
      Text("555555"),
      Text("6666666"),
      Text("777777"),
      Text("888888"),
      Text("999999"),
      Text("1010101010"),
    ];
  }
}

class _FlowDelegate extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {
    var dx = 0.0;
    var dy = 0.0;
    for (int i = 0; i < context.childCount; i++) {
//      if (dx + context.getChildSize(i).width > context.size.width) {
//        dx = 0;
//        dy += context.getChildSize(i).height;
//      }
//      context.paintChild(
//        i,
//        transform: Matrix4.compose(
//          Vector.Vector3(dx, dy, 0),
//          Vector.Quaternion(0, 0, 0, 0),
//          Vector.Vector3(1, 1, 1),
//        ),
//      );
//      dx += context.getChildSize(i).width;
      // 超出一行统统丢掉
      if (dx + context.getChildSize(i).width < context.size.width) {
        context.paintChild(
          i,
          transform: Matrix4.compose(
            Vector.Vector3(dx, dy, 0),
            Vector.Quaternion(0, 0, 0, 0),
            Vector.Vector3(1, 1, 1),
          ),
        );
        dx += context.getChildSize(i).width;
      }

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
