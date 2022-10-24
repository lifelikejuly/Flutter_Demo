import 'package:flutter/widgets.dart';
import '../parameter/animation_group.dart';
import '../manager/animation_manager.dart';
import '../manager/animation_driver.dart';

class AnimationGroupWidget extends StatefulWidget {
  final Widget child;
  final List<AbsAnimationGroup> animationGroups;
  final AnimationDriver animationDriver;

  AnimationGroupWidget({
    @required this.child,
    @required this.animationGroups,
    @required this.animationDriver,
  });

  @override
  State<AnimationGroupWidget> createState() => _AnimationGroupWidgetState();
}

class _AnimationGroupWidgetState extends State<AnimationGroupWidget>
    with TickerProviderStateMixin {
  AnimationDriver get animationDriver => widget.animationDriver;
  AnimationController _animationController;
  AnimationManager _animationManager;

  double _getMilliseconds() {
    double allTime = _animationController.duration.inMicroseconds.toDouble() /
        Duration.microsecondsPerMillisecond;
    return allTime * _animationController.value;
  }

  @override
  void initState() {
    super.initState();

    _animationManager = AnimationManager(widget.animationGroups);
    _animationController = AnimationController(vsync: this);
    _animationController.duration = _animationManager.duration;
    animationDriver.reverseFunc = () {
      _animationManager.isReverse(true);
      _animationController?.reverse(from: animationDriver.from);
    };

    animationDriver.forwardFunc = () {
      _animationManager.isReverse(false);
      _animationController?.forward(from: animationDriver.from);
    };
    animationDriver.resetFunc = () {
      _animationController.reset();
      _animationManager?.reset();
    };
    animationDriver.init();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: widget.child,
      builder: (context, child) {
        return Opacity(
          opacity: 1.0,
          child: Transform(
            transform: _animationManager.calculateMatrix(_getMilliseconds()),
            child: child,
            alignment: Alignment.center,
          ),
        );
      },
    );
  }
}
