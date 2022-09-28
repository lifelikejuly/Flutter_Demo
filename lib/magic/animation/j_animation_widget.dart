import 'package:flutter/widgets.dart';
import 'package:flutter_demo/magic/animation/j_animation_info.dart';

class JAnimationWidget extends StatefulWidget {
  final Widget child;
  final List<JAnimationInfo> animations;
  final JAnimationController jAnimationController;

  JAnimationWidget({
    @required this.child,
    @required this.animations,
    @required this.jAnimationController,
  });

  @override
  State<JAnimationWidget> createState() => _JAnimationWidgetState();
}

class _JAnimationWidgetState extends State<JAnimationWidget>
    with TickerProviderStateMixin {
  JAnimationController get jAnimationController => widget.jAnimationController;

  List<JAnimationInfo> get animations => widget.animations;

  Widget get child => widget.child;

  JAnimationManager _jAnimationManager;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _jAnimationManager = JAnimationManager(animations);
    jAnimationController.init(this, _jAnimationManager.duration);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: jAnimationController._animationController,
      child: widget.child,
      builder: (context, child) {
        return Opacity(
          opacity: _jAnimationManager
              .calculateOpacity(jAnimationController.getMilliseconds()),
          child: Transform(
            transform: _jAnimationManager
                .calculateMatrix(jAnimationController.getMilliseconds()),
            child: child,
            alignment: Alignment.center,
            // origin: Offset(0, 0),
          ),
        );
      },
    );
  }
}

class JAnimationController {
  bool autoPlay = false;
  bool repeat = false;
  bool reverse = false;
  double lowerBound;
  double upperBound;
  AnimationController _animationController;

  toForward({double from}) {
    _animationController?.forward(from: from);
  }

  toReverse({double from}) {
    _animationController?.reverse(from: from);
  }

  JAnimationController({
    this.autoPlay = false,
    this.repeat = false,
    this.reverse = false,
    double lowerBound = 0.0,
    double upperBound = 1.0,
  })  : this.lowerBound = lowerBound.clamp(0.0, 1.0),
        this.upperBound = upperBound.clamp(0.0, 1.0);

  init(TickerProvider vsync, Duration duration) {
    _animationController = AnimationController(
        vsync: vsync,
        lowerBound: lowerBound,
        upperBound: upperBound,
        duration: duration,
        reverseDuration: duration);
    _animationController.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.completed:
          if (repeat) {
            _animationController.forward(from: lowerBound);
          }
          break;
        case AnimationStatus.dismissed:
          if (repeat) {
            _animationController.reverse(from: upperBound);
          }
          break;
      }
    });
    if (autoPlay) {
      if (reverse) {
        _animationController.reverse(from: upperBound);
      } else {
        _animationController.forward(from: lowerBound);
      }
    }
  }

  // 获取时间
  double getMilliseconds() {
    // bool _getDirect() {
    //   bool loading = reverse
    //       ? (_animationController.status == AnimationStatus.reverse ||
    //           _animationController.status == AnimationStatus.completed)
    //       : (_animationController.status == AnimationStatus.forward ||
    //           _animationController.status == AnimationStatus.dismissed);
    //   return loading;
    // }
    //
    // double _getProgressMilliseconds() {
    //   // print("<> _getProgressMilliseconds. ${_animationController.value} ${_animationController?.lastElapsedDuration?.inMicroseconds
    //   //     ?.toDouble()}");
    //   bool isUpRight = _getDirect();
    //   return (isUpRight ? lowerBound : -(1.0 - upperBound)) *
    //       _animationController.duration.inMicroseconds.toDouble() /
    //       Duration.microsecondsPerMillisecond;
    // }
    //
    // double _getEmptyMilliseconds() {
    //   bool isUpRight = _getDirect();
    //   return (isUpRight
    //       ? 0.0
    //       : upperBound * _animationController.duration.inMicroseconds.toDouble());
    // }

    // return  ((_animationController?.lastElapsedDuration?.inMicroseconds
    //                 ?.toDouble() ??
    //             _getEmptyMilliseconds()) /
    //         Duration.microsecondsPerMillisecond);
    double allTime = _animationController.duration.inMicroseconds.toDouble() /
        Duration.microsecondsPerMillisecond;
    return allTime * _animationController.value;
  }
}
