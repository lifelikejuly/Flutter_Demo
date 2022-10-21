import 'dart:math';

import 'package:vector_math/vector_math_64.dart';

import 'animation_group.dart';

class AnimationManager {
  List<AbsAnimationGroup> groups;
  Duration duration;
  Matrix4 matrix4 = Matrix4.identity();

  AnimationManager(this.groups) {
    int maxDuration = 0;
    for (AbsAnimationGroup group in groups) {
      maxDuration = max(group.duration, maxDuration);
    }
    duration = Duration(milliseconds: maxDuration);
  }

  Matrix4 calculateMatrix(double millTime) {
    Matrix4 outPutMatrix4 = Matrix4.identity();
    for (AbsAnimationGroup group in groups) {
      if (group.overTime(millTime)) outPutMatrix4 = group.last(outPutMatrix4);
      if (group.inTime(millTime))
        outPutMatrix4 = group.calculate(outPutMatrix4, millTime);
    }
    return outPutMatrix4;
  }
}
