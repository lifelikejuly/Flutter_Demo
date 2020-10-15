import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/diy_scroll_physics.dart';
import 'package:flutter_demo/page/common/common.dart';

class DIYScrollDemo extends StatefulWidget {
  @override
  _DIYScrollDemoState createState() => _DIYScrollDemoState();
}

class _DIYScrollDemoState extends State<DIYScrollDemo> {
  @override
  Widget build(BuildContext context) {
    return _childContent();
  }

  _childContent() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Common.getWidget(index);
      },
      itemCount: 20,
      physics: DIYBouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
    );
  }
}
