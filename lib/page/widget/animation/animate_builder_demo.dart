
import 'package:flutter/material.dart';

class AnimateBuilderDemo extends StatefulWidget {

  @override
  State<AnimateBuilderDemo> createState() => _AnimateBuilderDemoState();
}

class _AnimateBuilderDemoState extends State<AnimateBuilderDemo> with TickerProviderStateMixin{

  AnimationController _scaleAnimationController;
  Animation<double> scale;

  @override
  void initState() {
    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    scale = Tween(begin: 1.0, end: 1.29).animate(_scaleAnimationController);
    super.initState();
  }

  @override
  void dispose() {
    _scaleAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scale,
      builder: (context, widget) {
        return Transform.scale(
          alignment: Alignment.centerLeft,
          scale: scale.value,
          child: widget,
        );
      },
      child: GestureDetector(
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          color: Colors.blue,
          width: 100,
          height: 50,
          child: Text("AnimatedBuilder"),
        ),
        onTap: (){
          _scaleAnimationController.forward();
        },
      ),
    );
  }
}
