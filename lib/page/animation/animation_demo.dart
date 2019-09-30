import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimationDemo extends StatefulWidget {
  @override
  _AnimationDemoState createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo>
    with TickerProviderStateMixin {
  AnimationController _toMaxAnimationController;
  Animation _animation;
  double _value;

  @override
  void initState() {
    super.initState();
    _toMaxAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _animation = Tween<double>(begin: 100, end: 0).animate(CurvedAnimation(
        parent: _toMaxAnimationController, curve: Curves.easeOutQuart))
      ..addListener(() {
        print("dragdemo _setToMaxAnimation    ${_animation.value}");
        setState(() {
          _value = _animation.value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("$_value"),
            RaisedButton(
              child: Text("start"),
              onPressed: () {
                _toMaxAnimationController.reset();
                _toMaxAnimationController.forward();
              },
            )
          ],
        ),
      ),
    );
  }
}
