import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';
import 'animation_part.dart';

// 动画组
abstract class AbsAnimationGroup {
  List<AnimationPart> _parts;
  Vector3 _currentXYZ = Vector3.all(0.0);
  int _duration;
  int _startMoment;
  int _endMoment;
  int _step = 0;
  bool _isReverse = true;

  List<AnimationPart> get parts => _parts;

  int get duration => _duration;

  Vector3 get lastXYZ => _currentXYZ;

  AbsAnimationGroup({List<AnimationPart> parts})
      : assert(parts != null && parts.isNotEmpty && parts.length > 1,
            "AnimationPart list must be not null and size > 1") {
    //动画序列调整
    _parts = parts;
    _parts.sort((a, b) {
      return a.moment.compareTo(b.moment);
    });
    //计算得到时长
    _duration = _parts.last.moment;
    _startMoment = _parts.first.moment;
    _endMoment = _duration;
  }

  Vector3 _getCurrentValue(double t) {
    if (_step >= parts.length || t < _startMoment) return _currentXYZ;
    AnimationPart currentPart = parts[_step];
    Vector3 value;
    if (_isReverse) {
      value = _reverse(currentPart, t);
    } else {
      value = _getForwardValue(currentPart, t);
    }
    if (value != null) {
      _currentXYZ = value;
      return value;
    }
    return _getCurrentValue(t);
  }

  Vector3 _getForwardValue(AnimationPart currentPart, double t) {
    AnimationPart leftPart;
    AnimationPart rightPart;
    if (currentPart.moment <= t) {
      if (_step + 1 < parts.length) {
        rightPart = parts[_step + 1];
        if (rightPart != null && rightPart.moment > t) {
          // 当下一个节点大于当前时间 做计算
          return _calculatePartXYZ(t, rightPart, currentPart);
        }
      } else {
        leftPart = parts[_step - 1];
        return _calculatePartXYZ(t, currentPart, leftPart);
      }
    }
    _step++;
    return null;
  }

  Vector3 _reverse(AnimationPart currentPart, double t) {
    AnimationPart leftPart;
    AnimationPart rightPart;
    if (currentPart.moment >= t) {
      if (_step - 1 >= 0) {
        leftPart = parts[_step - 1];
        if (leftPart != null && leftPart.moment < t) {
          // 当下一个节点大于当前时间 做计算
          return _calculatePartXYZ(t, currentPart, leftPart);
        }
      } else {
        rightPart = parts[_step + 1];
        return _calculatePartXYZ(t, rightPart, currentPart);
      }
    }
    _step--;
    return null;
  }

  Vector3 _calculatePartXYZ(double t, AnimationPart right, AnimationPart left) {
    int moment = right.moment - left.moment;
    double per = (t - left.moment) / moment.toDouble();
    return left.xyz + (right.xyz - left.xyz) * left.curve.transform(per);
  }

  // 判断是否在时间范围内
  bool _inTime(double time) {
    return _startMoment <= time && _endMoment >= time;
  }

  // 是否超出时间范围
  bool _overTime(double time) {
    return _endMoment < time;
  }

  Matrix4 _last(Matrix4 matrix4);

  Matrix4 _calculate(Matrix4 matrix4, double t);

  Matrix4 getCurrentMatrix4(Matrix4 matrix4, double t) {
    if (_overTime(t)) matrix4 = _last(matrix4);
    if (_inTime(t)) matrix4 = _calculate(matrix4, t);
    return matrix4;
  }

  void reset() {
    _step = 0;
  }

  void setReverse(bool reverse) {
    _isReverse = reverse;
    _step = reverse ? (_parts.length - 1) : 0;
    _currentXYZ =
        reverse ? _getCurrentValue(_endMoment.toDouble()) : Vector3.all(0.0);
  }
}

class TransitionAnimationGroup extends AbsAnimationGroup {
  TransitionAnimationGroup({@required List<AnimationPart> parts})
      : super(parts: parts);

  @override
  Matrix4 _calculate(Matrix4 matrix4, double t) {
    Vector3 xyz = _getCurrentValue(t);
    return matrix4..setTranslation(xyz);
  }

  @override
  Matrix4 _last(Matrix4 matrix4) {
    return matrix4..setTranslation(_currentXYZ);
  }
}

class ScaleAnimationGroup extends AbsAnimationGroup {
  ScaleAnimationGroup({@required List<AnimationPart> parts})
      : super(parts: parts);

  @override
  Matrix4 _calculate(Matrix4 matrix4, double t) {
    Vector3 xyz = _getCurrentValue(t);
    return matrix4..scale(xyz);
  }

  @override
  Matrix4 _last(Matrix4 matrix4) {
    return matrix4..scale(_currentXYZ);
  }
}

class RotationAnimationGroup extends AbsAnimationGroup {
  RotationAnimationGroup({@required List<AnimationPart> parts})
      : super(parts: parts);

  @override
  Matrix4 _calculate(Matrix4 matrix4, double t) {
    Vector3 xyz = _getCurrentValue(t);
    matrix4.rotateX(xyz.x);
    matrix4.rotateY(xyz.y);
    matrix4.rotateZ(xyz.z);
    return matrix4;
  }

  @override
  Matrix4 _last(Matrix4 matrix4) {
    matrix4.rotateX(_currentXYZ.x);
    matrix4.rotateY(_currentXYZ.y);
    matrix4.rotateZ(_currentXYZ.z);
    return matrix4;
  }
}

// abstract class AbsAnimationGroups<T extends AbsAnimationGroup> {
//   List<T> groups;
//   Duration duration;
//   Matrix4 matrix4 = Matrix4.identity();
//
//   AbsAnimationGroups(this.groups) {
//     int maxDuration = 0;
//     for (AbsAnimationGroup group in groups) {
//       maxDuration = max(group.duration, maxDuration);
//     }
//     duration = Duration(milliseconds: maxDuration);
//   }
//
//   Matrix4 calculateMatrix(double millTime) {
//     Matrix4 outPutMatrix4 = Matrix4.identity();
//     for (AbsAnimationGroup group in groups) {
//       if (group.overTime(millTime)) outPutMatrix4 = group.last(outPutMatrix4);
//       if (group.inTime(millTime))
//         outPutMatrix4 = group.calculate(outPutMatrix4, millTime);
//     }
//     return outPutMatrix4;
//   }
// }
//
// class TransitionAnimationGroups
//     extends AbsAnimationGroups<TransitionAnimationGroup> {
//   TransitionAnimationGroups({@required List<TransitionAnimationGroup> groups})
//       : super(groups);
// }

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
