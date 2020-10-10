import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';

class SliverListWheelDemo extends StatefulWidget {
  @override
  _SliverListWheelDemoState createState() => _SliverListWheelDemoState();
}

class _SliverListWheelDemoState extends State<SliverListWheelDemo> {
  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      diameterRatio: 1.5,
      perspective: 0.01,
      offAxisFraction: -0.5,
//      useMagnifier: true, // 使用放大镜
//      magnification: 2, // 放大倍数
      overAndUnderCenterOpacity: 1.0, //透明度
      squeeze: 1,
      clipToSize: false,
      renderChildrenOutsideViewport: true,
      itemExtent: 100,
      onSelectedItemChanged: (index){
        print("ListWheelScrollView onSelectedItemChanged $index");
      },
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          return Common.getWidget(index);
        },
        childCount: 100,
      ),
    );
  }
}
