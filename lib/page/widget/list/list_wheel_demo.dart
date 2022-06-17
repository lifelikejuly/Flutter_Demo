import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';

class ListWheelDemo extends StatefulWidget {
  @override
  _ListWheelDemoState createState() => _ListWheelDemoState();
}

class _ListWheelDemoState extends State<ListWheelDemo> {
  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      diameterRatio: 1.5,
      perspective: 0.01,
      offAxisFraction: -0.5,
//      useMagnifier: true, // 使用放大镜
//      magnification: 2, // 放大倍数
      overAndUnderCenterOpacity: 1.0,
      //透明度
      squeeze: 1,
      renderChildrenOutsideViewport: true,
      itemExtent: 100,
      onSelectedItemChanged: (index) {
        print("ListWheelScrollView onSelectedItemChanged $index");
      },
      clipBehavior: Clip.none,
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          return Common.getWidget(index);
        },
        childCount: 100,
      ),
    );
  }
}
