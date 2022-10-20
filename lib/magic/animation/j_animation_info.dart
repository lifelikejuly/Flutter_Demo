import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

abstract class BaseAnimationInfo {
  // 平移 缩放 透明度 旋转
  String animationType; // transition , scale, opacity , rotation
  int startTime; // mill
  int endTime;

  BaseAnimationInfo({
    @required this.animationType,
    @required this.startTime,
    @required this.endTime,
  });
}

class JAnimationInfo {
  // 平移 缩放 透明度 旋转
  Animation animationType; // transition , scale, opacity , rotation
  Vector3 startValue;
  Vector3 endValue;
  int startTime; // mill
  int endTime;

  double startX;
  double startY;
  double startZ;

  double endX;
  double endY;
  double endZ;

  // JAnimationInfo._();

  JAnimationInfo._({
    @required this.animationType,
    @required this.startTime,
    @required this.endTime,
    this.startX = 1.0,
    this.startY = 1.0,
    this.startZ = 1.0,
    this.endX = 1.0,
    this.endY = 1.0,
    this.endZ = 1.0,
  })  : startValue = Vector3(startX, startY, startZ),
        endValue = Vector3(endX, endY, endZ);

  JAnimationInfo.scale({
    @required this.startTime,
    @required this.endTime,
    this.startX = 1.0,
    this.startY = 1.0,
    this.startZ = 1.0,
    this.endX = 1.0,
    this.endY = 1.0,
    this.endZ = 1.0,
  })  : animationType = Animation.SCALE,
        startValue = Vector3(startX, startY, startZ),
        endValue = Vector3(endX, endY, endZ);

  JAnimationInfo.transition({
    @required this.startTime,
    @required this.endTime,
    this.startX = 0.0,
    this.startY = 0.0,
    this.startZ = 0.0,
    this.endX = 0.0,
    this.endY = 0.0,
    this.endZ = 0.0,
  })  : animationType = Animation.TRANSITION,
        startValue = Vector3(startX, startY, startZ),
        endValue = Vector3(endX, endY, endZ);

  JAnimationInfo.rotation({
    @required this.startTime,
    @required this.endTime,
    this.startX = 0.0,
    this.startY = 0.0,
    this.startZ = 0.0,
    this.endX = 0.0,
    this.endY = 0.0,
    this.endZ = 0.0,
  })  : animationType = Animation.ROTATION,
        startValue = Vector3(startX, startY, startZ),
        endValue = Vector3(endX, endY, endZ);

  JAnimationInfo.opacity({
    @required this.startTime,
    @required this.endTime,
    this.startX = 1.0,
    this.endX = 1.0,
  })  : animationType = Animation.OPACITY,
        startValue = Vector3(startX, startX, startX),
        endValue = Vector3(endX, endX, endX);

  JAnimationInfo clone() {
    return JAnimationInfo._(
      animationType: this.animationType,
      startTime: this.startTime,
      endTime: this.endTime,
      startX: this.startX,
      startY: this.startY,
      startZ: this.startZ,
      endX: this.endX,
      endY: this.endY,
      endZ: this.endZ,
    );
  }
}

enum Animation {
  SCALE,
  ROTATION,
  TRANSITION,
  OPACITY,
}

/// Animation All List class
class JAnimationManager {

  Map<Animation, Vector3> _animationValueMap = {
    Animation.SCALE: Vector3.all(1.0),
    Animation.ROTATION: Vector3.all(0.0),
    Animation.TRANSITION: Vector3.all(0.0),
    Animation.OPACITY: Vector3.all(1.0),
  };

  Map<Animation, List<JAnimationInfo>> _animationInfoMap = {
    Animation.SCALE: List.empty(growable: true),
    Animation.ROTATION: List.empty(growable: true),
    Animation.TRANSITION: List.empty(growable: true),
    Animation.OPACITY: List.empty(growable: true),
  };

  resetInit() {
    _animationValueMap = {
      Animation.SCALE: Vector3.all(1.0),
      Animation.ROTATION: Vector3.all(0.0),
      Animation.TRANSITION: Vector3.all(0.0),
      Animation.OPACITY: Vector3.all(1.0),
    };
  }

  reverseInit(){
    calculateMaxOpacity();
    calculateMaxMatrix();
  }

  Duration _duration;

  /// calculate Opacity Value
  double calculateOpacity(double millTime) {
    Vector3 value = _animationValueMap[Animation.OPACITY];
    for (JAnimationInfo animation in _animationInfoMap[Animation.OPACITY]) {
      value = _calculateValue(millTime, animation);
      value ??= _animationValueMap[Animation.OPACITY];
      _animationValueMap[Animation.OPACITY] = value;
    }
    value ??= _animationValueMap[Animation.OPACITY];
    return value.x.clamp(0.0, 1.0);
  }

  calculateMaxOpacity() {
    Vector3 value = _animationValueMap[Animation.OPACITY];
    int endTime = 0;
    for (JAnimationInfo animation in _animationInfoMap[Animation.OPACITY]) {
      if(animation.endTime >= endTime ){
        value = animation.endValue;
        endTime = animation.endTime;
      }
      value ??= _animationValueMap[Animation.OPACITY];
      _animationValueMap[Animation.OPACITY] = value;
    }
  }

  /// calculate Animation Matrix
  Matrix4 calculateMatrix(double millTime) {
    Matrix4 matrix4 = Matrix4.identity();
    Vector3 value;
    matrix4.scale(_animationValueMap[Animation.SCALE]);
    value = _animationValueMap[Animation.ROTATION];
    matrix4.rotateX(value.x);
    matrix4.rotateY(value.y);
    matrix4.rotateZ(value.z);
    matrix4.setTranslation(_animationValueMap[Animation.TRANSITION]);
    for (JAnimationInfo animation in _animationInfoMap[Animation.SCALE]) {
      value = _calculateValue(millTime, animation);
      value ??= _animationValueMap[Animation.SCALE];
      matrix4.scale(value);
      _animationValueMap[Animation.SCALE] = value;
    }
    for (JAnimationInfo animation in _animationInfoMap[Animation.ROTATION]) {
      value = _calculateValue(millTime, animation);
      value ??= _animationValueMap[Animation.ROTATION];
      matrix4.rotateX(value.x);
      matrix4.rotateY(value.y);
      matrix4.rotateZ(value.z);
      _animationValueMap[Animation.ROTATION] = value;
    }
    for (JAnimationInfo animation in _animationInfoMap[Animation.TRANSITION]) {
      value = _calculateValue(millTime, animation);
      value ??= _animationValueMap[Animation.TRANSITION];
      matrix4.setTranslation(value);
      _animationValueMap[Animation.TRANSITION] = value;
    }
    return matrix4;
  }

  calculateMaxMatrix() {
    int endTime = 0;
    Vector3 value;
    for (JAnimationInfo animation in _animationInfoMap[Animation.SCALE]) {
      if(animation.endTime >= endTime){
        value = animation.endValue;
      }
      value ??= _animationValueMap[Animation.SCALE];
      _animationValueMap[Animation.SCALE] = value;
    }
    for (JAnimationInfo animation in _animationInfoMap[Animation.ROTATION]) {
      if(animation.endTime >= endTime){
        value = animation.endValue;
      }
      value ??= _animationValueMap[Animation.ROTATION];
      _animationValueMap[Animation.ROTATION] = value;
    }
    for (JAnimationInfo animation in _animationInfoMap[Animation.TRANSITION]) {
     if(animation.endTime >= endTime){
        value = animation.endValue;
      }
      value ??= _animationValueMap[Animation.TRANSITION];
      _animationValueMap[Animation.TRANSITION] = value;
    }
  }

  /// calculate Animation Value
  Vector3 _calculateValue(double millTime, JAnimationInfo animation) {
    Vector3 value;
    if (animation.startTime <= millTime && animation.endTime >= millTime) {
      double pre = (millTime - animation.startTime) /
          (animation.endTime - animation.startTime);
      value = animation.startValue +
          (animation.endValue - animation.startValue) * pre;
    } else {
      return null;
    }
    return value;
  }

  int startTime = 0;
  int endTime = 0;

  JAnimationManager(List<JAnimationInfo> animations) {
    addAnimations(animations);
  }

  addAnimations(List<JAnimationInfo> animations){
     animations.forEach((element) {
      int elementStartTime = element.startTime;
      int elementEndTime = element.endTime;
      startTime = min(elementStartTime, startTime);
      endTime = max(elementEndTime, endTime);
      _appendAnimation(_animationInfoMap[element.animationType], element);
    });
    _duration = Duration(milliseconds: endTime - startTime);
  }

  /// all Duration
  Duration get duration => _duration;

  // 整合动画入参
  _appendAnimation(
      List<JAnimationInfo> animations, JAnimationInfo jAnimationInfo) {
    animations.add(jAnimationInfo);
    return;
    if (animations.isEmpty) {
      // 空集合直接添加
      animations.add(jAnimationInfo);
    } else {
      // TODO 对于输入值 进行内部处理符合输入
      // 列举所有存在的情况
      // 1. 不重合（大于或者小于）
      // 2. 覆盖 （首尾都大于）
      //

      // JAnimationInfo animationInfo = animations.last;
      // int oldStartTime = animationInfo.startTime;
      // int oldEndTime = animationInfo.endTime;
      //
      // int newStartTime = jAnimationInfo.startTime;
      // int newEndTime = jAnimationInfo.endTime;
      //
      // if (oldEndTime < newStartTime) {
      //   animations.add(animationInfo.clone()
      //     ..startTime = oldEndTime
      //     ..endTime = newStartTime
      //   );
      //   animations.add(jAnimationInfo);
      // }
    }
  }
}
