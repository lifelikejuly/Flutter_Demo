import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/magic/animation/j_animation_info.dart';
import 'package:flutter_demo/magic/animation/j_animation_widget.dart';

class TestAnimationDemo extends StatefulWidget {
  @override
  State<TestAnimationDemo> createState() => _TestAnimationDemoState();
}

class _TestAnimationDemoState extends State<TestAnimationDemo> {
  JAnimationController jAnimationController;

  @override
  void initState() {
    super.initState();
    jAnimationController = JAnimationController(autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 0,
            left: 0,
            child: JAnimationWidget(
              jAnimationController: jAnimationController,
              animations: [
                // JAnimationInfo.transition(
                //     startY: -400, endY: 0, startTime: 0, endTime: 1000),
                // JAnimationInfo.scale(
                //     startX: 1.0,
                //     endX: 0.0,
                //     startY: 1.0,
                //     endY: 0.0,
                //     startTime: 2000,
                //     endTime: 3000),
                // JAnimationInfo.opacity(
                //     startX: 1.0, endX: 0.0, startTime: 2000, endTime: 3000),
                JAnimationInfo.transition(
                    startX: 0,
                    endX: 200,
                    startY: 0,
                    endY: 200,
                    startTime: 0,
                    endTime: 2000),
                // JAnimationInfo.transition(
                //     startX: 0,
                //     endX: -400,
                //     startY: 0,
                //     endY: -400,
                //     startTime: 2000,
                //     endTime: 3000),

                // JAnimationInfo.transition(
                //     startY: 0, endY: 100, startTime: 0, endTime: 1000),
                // JAnimationInfo.transition(
                //     startX: 0,
                //     endX: -200,
                //     startY: 200,
                //     endY: 0,
                //     startTime: 2000,
                //     endTime: 3000),
                // JAnimationInfo.scale(
                //     startX: 1.0, endX: 0.0,startY: 1.0,endY: 0.0, startTime: 2000, endTime: 3000),
                // JAnimationInfo.opacity(
                //     startX: 1.0, endX: 0.0,startTime: 0, endTime: 2000),
                // JAnimationInfo.opacity(
                //     startX: 0.0, endX: 1.0,startTime: 2000, endTime: 4000),
                // JAnimationInfo.scale(
                //     startX: 0.2,
                //     startY: 0.2,
                //     endX: 2.0,
                //     endY: 2.0,
                //     startTime: 1000,
                //     endTime: 2000),
                // JAnimationInfo.transition(
                //     startX: 0, endX: 200, startTime: 1000, endTime: 2000),
                // JAnimationInfo.rotation(
                //     startZ: 10, endZ: 20, startTime: 1000, endTime: 2000),
                // JAnimationInfo.opacity(
                //     startTime: 0, endTime: 1000, startX: 1.0, endX: 0.0),
                // JAnimationInfo.opacity(
                //     startTime: 1000, endTime: 2000, startX: 0.0, endX: 1.0),
              ],
              child: Container(
                child: Text("llll"),
                width: 20,
                height: 20,
                color: Colors.red,
              ),
            )),
      ],
    );
  }
}
