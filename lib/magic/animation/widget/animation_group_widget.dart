import 'package:flutter/widgets.dart';
import 'package:flutter_demo/magic/animation/parameter/animation_group.dart';
import 'package:flutter_demo/magic/animation/parameter/animation_manager.dart';

class AnimationGroupWidget extends StatefulWidget {
  final Widget child;
  final List<AbsAnimationGroup> animationGroups;

  AnimationGroupWidget({
    @required this.child,
    @required this.animationGroups,
  });

  @override
  State<AnimationGroupWidget> createState() => _AnimationGroupWidgetState();
}

class _AnimationGroupWidgetState extends State<AnimationGroupWidget>
    with TickerProviderStateMixin {
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
    _animationController = AnimationController(vsync: this);
    _animationManager = AnimationManager(widget.animationGroups);
    _animationController.duration = _animationManager.duration;
    _animationController.forward(from: 0);
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
