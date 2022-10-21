import 'package:flutter/widgets.dart';

import 'j_animation_info.dart';

class JAnimationController {
  bool autoPlay = false;
  bool repeat = false;
  bool reverse = false;
  double lowerBound;
  double upperBound;
  AnimationController _animationController;

  JAnimationManager _manager;

  AnimationController get animationController => _animationController;

  toForward({double from}) {
    reverse = false;
    _manager.resetInit();
    _animationController?.forward(from: from);
  }

  toReverse({double from}) {
    reverse = true;
    _manager.reverseInit();
    _animationController?.reverse(from: from);
  }

  addAnimations(List<JAnimationInfo> animations){
    _manager.addAnimations(animations);
    _animationController.duration = _manager.duration;
    _animationController.reverseDuration = _manager.duration;
  }

  JAnimationController({
    this.autoPlay = false,
    this.repeat = false,
    this.reverse = false,
    double lowerBound = 0.0,
    double upperBound = 1.0,
  })  : this.lowerBound = lowerBound.clamp(0.0, 1.0),
        this.upperBound = upperBound.clamp(0.0, 1.0);

  init(TickerProvider vsync, JAnimationManager manager) {
    _manager = manager;
    _animationController = AnimationController(
        vsync: vsync,
        lowerBound: lowerBound,
        upperBound: upperBound,
        duration: manager.duration,
        reverseDuration: manager.duration);
    _animationController.addListener(() {
      double vaule = _animationController.value;
      if(vaule == 1.0 && !reverse){
          if (repeat) {
            toForward(from: lowerBound);
          }
      }else if(vaule == 0.0 && reverse){
        if (repeat) {
            toReverse(from: upperBound);
          }
      }

    });   
    // _animationController.addStatusListener((status) {
    //   switch (status) {
    //     case AnimationStatus.completed:
    //      print("<> AnimationStatus.completed");
    //       if (repeat) {
    //         _animationController.forward(from: lowerBound);
    //       }
    //       break;
    //     case AnimationStatus.dismissed:

    //       if (repeat) {
    //         _animationController.value = upperBound;
    //         _animationController.reverse(from: upperBound);
    //       }
    //       break;
    //     default:
    //       break;
    //   }
    // });
    if (autoPlay) {
      if (reverse) {
        _animationController.reverse(from: upperBound);
      } else {
        _animationController.forward(from: lowerBound);
      }
    }
  }

  double get getAllTime => _animationController.duration.inMicroseconds.toDouble() /
        Duration.microsecondsPerMillisecond;

  // 获取时间
  double getMilliseconds() {
    double allTime = _animationController.duration.inMicroseconds.toDouble() /
        Duration.microsecondsPerMillisecond;
    return allTime * _animationController.value;
  }
}
