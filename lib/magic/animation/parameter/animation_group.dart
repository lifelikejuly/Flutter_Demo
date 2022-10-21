import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';
import 'animation_part.dart';

abstract class AbsAnimationGroup {
  List<AnimationPart> _parts;
  Vector3 _currentXYZ = Vector3.all(0.0);
  int _duration;
  int _startMoment;
  int _endMoment;

  List<AnimationPart> get parts => _parts;

  int get duration => _duration;

  Vector3 get lastXYZ => _currentXYZ;

  AbsAnimationGroup({List<AnimationPart> parts})
      : assert(parts != null && parts.isNotEmpty, "list must be not null") {
    //
    _parts = parts;
    _parts.sort((a, b) {
      return a.moment.compareTo(b.moment);
    });
    //
    _duration = _parts.last.moment;
    _startMoment = _parts.first.moment;
    _endMoment = _duration;
  }

  Vector3 _getCurrentValue(double t) {
    for (int i = 0; i < parts.length; i++) {
      AnimationPart leftPart;
      AnimationPart rightPart;
      AnimationPart current = parts[i];
      int currentMoment = current.moment;
      Vector3 currentXYZ = current.xyz;
      Curve currentCurve = current.curve;
      if (currentMoment <= t) {
        // 节点小于当前时间
        if (i + 1 < parts.length) {
          // 寻找下一个节点
          rightPart = parts[i + 1];
          int rightMoment = rightPart.moment;
          Vector3 rightXYZ = rightPart.xyz;
          if (rightMoment > t) {
            // 当下一个节点大于当前时间 做计算
            int moment = rightMoment - currentMoment;
            double per = (t - currentMoment) / moment.toDouble();
            _currentXYZ = currentXYZ + (rightXYZ - currentXYZ) * currentCurve.transform(per);
            return _currentXYZ;
          }
          leftPart = rightPart;
        } else if (leftPart != null) {
          int leftMoment = leftPart.moment;
          Vector3 leftXYZ = leftPart.xyz;
          int moment = currentMoment - leftMoment;
          double per = (t - leftMoment) / moment.toDouble();
          _currentXYZ = leftXYZ + (currentXYZ - leftXYZ) * per;
          return _currentXYZ;
        }
      } else {
        leftPart = current;
      }
    }
    return _currentXYZ;
  }

  bool inTime(double time) {
    return _startMoment <= time && _endMoment >= time;
  }

  bool overTime(double time) {
    return _endMoment < time;
  }

  Matrix4 last(Matrix4 matrix4);

  Matrix4 calculate(Matrix4 matrix4, double t);
}

class TransitionAnimationGroup extends AbsAnimationGroup {
  TransitionAnimationGroup({@required List<AnimationPart> parts})
      : super(parts: parts);

  @override
  Matrix4 calculate(Matrix4 matrix4, double t) {
    Vector3 xyz = _getCurrentValue(t);
    return matrix4..setTranslation(xyz);
  }
  
  @override
  Matrix4 last(Matrix4 matrix4) {
    return matrix4..setTranslation(_currentXYZ);
  }
}

class ScaleAnimationGroup extends AbsAnimationGroup{

  ScaleAnimationGroup({@required List<AnimationPart> parts})
      : super(parts: parts);

  @override
  Matrix4 calculate(Matrix4 matrix4, double t) {
    Vector3 xyz = _getCurrentValue(t);
    return matrix4..scale(xyz);
  }

  @override
  Matrix4 last(Matrix4 matrix4) {
    return matrix4..scale(_currentXYZ);
  }
}

abstract class AbsAnimationGroups<T extends AbsAnimationGroup> {
  List<T> groups;
  Duration duration;
  Matrix4 matrix4 = Matrix4.identity();

  AbsAnimationGroups(this.groups) {
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

class TransitionAnimationGroups
    extends AbsAnimationGroups<TransitionAnimationGroup> {
  TransitionAnimationGroups({@required List<TransitionAnimationGroup> groups})
      : super(groups);
}


// abstract class AbsAnimationGroups {
//   List<AbsAnimationParts> groups;
//   Duration duration;
//   Matrix4 matrix4 = Matrix4.identity();
//
//   AbsAnimationGroups(this.groups) {
//     int maxDuration = 0;
//     for (AbsAnimationParts group in groups) {
//       maxDuration = max(group.duration, maxDuration);
//     }
//     duration = Duration(milliseconds: maxDuration);
//   }
//
//   Matrix4 calculateMatrix(double millTime) {
//     Matrix4 outPutMatrix4 = Matrix4.identity();
//     for (AbsAnimationParts group in groups) {
//       if (group.inTime(millTime))
//         outPutMatrix4 = group.calculate(outPutMatrix4, millTime);
//     }
//     return outPutMatrix4;
//   }
// }
