import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/magic/animation/j_animation_info.dart';

class JAnimationWidget extends StatefulWidget {
  final Widget child;
  final List<JAnimationInfo> animations;

  JAnimationWidget({
    @required this.child,
    @required this.animations,
  });

  @override
  State<JAnimationWidget> createState() => _JAnimationWidgetState();
}

class _JAnimationWidgetState extends State<JAnimationWidget>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<JAnimationInfo> get animations => widget.animations;

  Widget get child => widget.child;

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    int startTime = 0;
    int endTime = 0;
    animations.forEach((element) {
      startTime = math.min(element.startTime, startTime);
      endTime = math.max(element.endTime, endTime);
    });
    Duration duration = Duration(milliseconds: endTime - startTime);
    animationController = AnimationController(vsync: this, duration: duration);
    animationController.addListener(() {});
    animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (context, child) {
        return Transform(
          transform: _calculateMatrix(),
          child: child,
          alignment: Alignment.center,
          // origin: Offset(0, 0),
        );
      },
    );
  }

  Matrix4 _calculateMatrix() {
    Matrix4 matrix4 = Matrix4.identity();
    double value;
    double millTime = _getMilliseconds() / Duration.microsecondsPerMillisecond;
    for (JAnimationInfo animation in animations) {
      if (animation.startTime <= millTime && animation.endTime >= millTime) {
        double pre = (millTime - animation.startTime) /
            (animation.endTime - animation.startTime);
        value = animation.startValue +
            (animation.endValue - animation.startValue) * pre;
      } else if (animation.startTime < millTime) {
        value = animation.startValue;
      } else if (animation.endTime > millTime) {
        value = animation.endValue;
      }
      switch (animation.animationType) {
        case "scale":
          matrix4.scale(Vector3(1, 1, value));
          break;
        case "rotation":
          matrix4.rotate(Vector3(1, 1, 1),value);
          break;
        case "transition":
          matrix4.translate(value);
          break;
      }
    }
    return matrix4;
  }

  double _getMilliseconds() {
    return animationController?.lastElapsedDuration?.inMicroseconds
            ?.toDouble() ??
        (animationController.status == AnimationStatus.forward
            ? 0.0
            : animationController.duration.inMicroseconds.toDouble());
  }
}
