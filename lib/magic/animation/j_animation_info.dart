import 'package:flutter/foundation.dart';

class JAnimationInfo {
  // 平移 缩放 透明度 旋转
  String animationType; // transition , scale, opacity , rotation
  double startValue;
  double endValue;
  int startTime; // mill
  int endTime;

  JAnimationInfo._();

  JAnimationInfo({
    @required this.animationType,
    @required this.startValue,
    @required this.endValue,
    @required this.startTime,
    @required this.endTime,
  });

  // JAnimationInfo.transition() {
  //   return JAnimationInfo();
  // }
}
