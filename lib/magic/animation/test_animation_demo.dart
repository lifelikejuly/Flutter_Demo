import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/magic/animation/j_animation_info.dart';
import 'package:flutter_demo/magic/animation/j_animation_widget.dart';

import 'j_animation_controller.dart';

import 'package:flutter_demo/magic/animation_group/animations.dart';

class TestAnimationDemo extends StatefulWidget {
  @override
  State<TestAnimationDemo> createState() => _TestAnimationDemoState();
}

class _TestAnimationDemoState extends State<TestAnimationDemo> {
  JAnimationController jAnimationController;
  bool _repeat = false;

  GlobalKey globalKey1 = GlobalKey();
  GlobalKey globalKey2 = GlobalKey();
  GlobalKey globalKey3 = GlobalKey();

  AnimationDriver animationDriver = AnimationDriver();

  @override
  void initState() {
    super.initState();
    jAnimationController = JAnimationController();
    jAnimationController.repeat = _repeat;

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox renderBox = globalKey1.currentContext.findRenderObject();
      Offset position = renderBox.localToGlobal(Offset.zero);

      RenderBox renderBox2 = globalKey2.currentContext.findRenderObject();
      Offset position2 = renderBox2.localToGlobal(Offset.zero);

      RenderBox renderBox3 = globalKey3.currentContext.findRenderObject();
      Offset position3 = renderBox3.localToGlobal(Offset.zero);

      jAnimationController.addAnimations([
        JAnimationInfo.transition(
            startX: 0,
            endX: position.dx,
            startY: 0,
            endY: position.dy,
            startTime: 0,
            endTime: 2000),
        JAnimationInfo.transition(
            startX: position.dx,
            endX: position2.dx,
            startY: position.dy,
            endY: position2.dy,
            startTime: 2000,
            endTime: 4000),
        JAnimationInfo.transition(
            startX: position2.dx,
            endX: position3.dx,
            startY: position2.dy,
            endY: position3.dy,
            startTime: 4000,
            endTime: 6000),
      ]);
    });

    animationDriver.reverse(from: 1.0);
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
              // JAnimationInfo.opacity(
              //     startX: 1.0, endX: 0.0, startTime: 2000, endTime: 3000),
              // JAnimationInfo.transition(
              //     startX: 0,
              //     endX: 200,
              //     startY: 0,
              //     endY: 200,
              //     startTime: 0,
              //     endTime: 2000),
            ],
            child: Container(
              child: Text("llll"),
              width: 20,
              height: 20,
              color: Colors.red,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: AnimationGroupWidget(
            animationDriver: animationDriver,
            animationGroups: [
              TransitionAnimationGroup(parts: [
                AnimationPart(moment: 0, x: 0, y: 0),
                AnimationPart(moment: 1000, x: 100, y: 100,curve: Curves.easeIn),
                AnimationPart(moment: 2000, x: 100, y: 200,curve: Curves.easeIn),
                AnimationPart(moment: 3000, x: 200, y: 200),
                AnimationPart(moment: 4000, x: 300, y: 300),
              ]),

              TransitionAnimationGroup(parts: [
                AnimationPart(moment: 5000, x: 300, y: 300),
                AnimationPart(moment: 6000, x: 200, y: 200),
              ]),

              // ScaleAnimationGroup(parts: [
              //   AnimationPart(moment: 1000, x: 1.0, y: 1.0,z: 1.0),
              //   AnimationPart(moment: 2000, x: 1.5, y: 1.5,z: 1.0,curve: Curves.easeIn),
              //   AnimationPart(moment: 3000, x: 1.0, y: 1.0,z: 1.0),
              // ]),
              //
              // ScaleAnimationGroup(parts: [
              //   AnimationPart(moment: 4000, x: 1.0, y: 1.0,z: 1.0,curve: Curves.bounceIn),
              //   AnimationPart(moment: 5000, x: 2.0, y: 2.0,z: 1.0),
              // ]),

              RotationAnimationGroup(
                  parts: [
                    AnimationPart(moment: 4000, x: 0, y: 0,z: 0,),
                    AnimationPart(moment: 5000, x: 0, y: 0,z: pi,),
                  ]
              ),
            ],
            child: Container(
              child: Text("xxxxx"),
              width: 20,
              height: 20,
              color: Colors.blue,
            ),
          ),
        ),
        Positioned(
            top: 100,
            left: 100,
            child: Container(
              key: globalKey1,
              child: Text("1"),
              width: 20,
              height: 20,
              color: Colors.red,
            )),
        Positioned(
            top: 150,
            left: 200,
            child: Container(
              key: globalKey2,
              child: Text("2"),
              width: 20,
              height: 20,
              color: Colors.red,
            )),
        Positioned(
            top: 300,
            left: 50,
            child: Container(
              key: globalKey3,
              child: Text("3"),
              width: 20,
              height: 20,
              color: Colors.red,
            )),
        Positioned(
            bottom: 0,
            child: Row(
              children: [
                TextButton(
                    onPressed: () {
                      jAnimationController.toForward(from: 0);
                      animationDriver.forward(from: 0);
                    },
                    child: Text("toForward")),
                TextButton(
                    onPressed: () {
                      jAnimationController.toReverse(from: 1.0);
                      animationDriver.reverse(from: 1.0);
                    },
                    child: Text("toReverse")),
                Switch(
                    value: _repeat,
                    onChanged: (newValue) {
                      _repeat = !_repeat;

                      jAnimationController.repeat = _repeat;
                      setState(() {});
                    }),
              ],
            )),
      ],
    );
  }
}
