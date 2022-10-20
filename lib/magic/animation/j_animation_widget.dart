import 'package:flutter/widgets.dart';
import 'package:flutter_demo/magic/animation/j_animation_info.dart';

import 'j_animation_controller.dart';

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
    jAnimationController.init(this, _jAnimationManager);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: jAnimationController.animationController,
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

