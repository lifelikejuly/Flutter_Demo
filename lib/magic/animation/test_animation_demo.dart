import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/magic/animation/j_animation_info.dart';
import 'package:flutter_demo/magic/animation/j_animation_widget.dart';

class TestAnimationDemo extends StatefulWidget {
  @override
  State<TestAnimationDemo> createState() => _TestAnimationDemoState();
}

class _TestAnimationDemoState extends State<TestAnimationDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: JAnimationWidget(
        animations: [
          JAnimationInfo(
              animationType: "scale",
              startValue: 1.0,
              endValue: 1.5,
              startTime: 0,
              endTime: 2000),
          JAnimationInfo(
              animationType: "transition",
              startValue: 10.0,
              endValue: 100.0,
              startTime: 0,
              endTime: 2000),
          JAnimationInfo(
              animationType: "rotation",
              startValue: 10,
              endValue: 13,
              startTime: 0,
              endTime: 2000),


        ],
        child: Container(
          child: Text("llll"),
          width: 200,
          height: 200,
          color: Colors.red,
        ),
      ),
    );
  }
}
