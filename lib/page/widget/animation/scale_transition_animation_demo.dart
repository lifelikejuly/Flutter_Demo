import 'package:flutter/material.dart';

class ScaleTransitionAnimationDemo extends StatefulWidget {
  @override
  State<ScaleTransitionAnimationDemo> createState() =>
      _TransitionAnimationDemoState();
}

class _TransitionAnimationDemoState extends State<ScaleTransitionAnimationDemo>
    with TickerProviderStateMixin {
  AnimationController _scaleAnimationController;
  Animation<double> scale;

  AnimationController _rectAnimationController;
  Animation<RelativeRect> rect;

  @override
  void initState() {
    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    scale = Tween(begin: 1.0, end: 1.29).animate(_scaleAnimationController);

    _rectAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    RelativeRectTween rectTween = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0, 100, 50, 100),
      end: RelativeRect.fromLTRB(0, 50, 0, 50),
    );

    //关联 controller
    rect = rectTween.animate(_rectAnimationController);
    super.initState();
  }

  @override
  void dispose() {
    _scaleAnimationController?.dispose();
    _rectAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.pink,
          height: 600,
          width: 600,
          child: Stack(
            children: [
              TextButton(
                  onPressed: () {
                    _rectAnimationController.forward();
                    _scaleAnimationController.forward();
                  },
                  child: Text("animation")),
              Container(
                margin: EdgeInsets.all(50),
                color: Colors.yellow.withOpacity(0.2),
                height: 200,
                width: 100,
              ),
              ScaleTransition(
                scale: scale,
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.all(50),
                  color: Colors.yellow,
                  height: 200,
                  width: 100,
                ),
              ),
              Positioned(
                top:250,
                child: ScaleTransition(
                  scale: scale,
                  child: Container(
                    margin: EdgeInsets.all(50),
                    color: Colors.yellow,
                    height: 200,
                    width: 100,
                  ),
                ),
              )
              // PositionedTransition(
              //   rect: rect,
              //   child: Container(
              //     width: 50,
              //     height: 50,
              //     color: Colors.blue,
              //     child: FlutterLogo(),
              //   ),
              // ),
            ],
          ),
        )
      ],
    );
  }
}
