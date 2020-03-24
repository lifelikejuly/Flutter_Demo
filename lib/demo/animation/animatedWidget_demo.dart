import 'package:flutter/material.dart';

class AnimatedWidgetDemo extends StatefulWidget {
  @override
  _AnimatedWidgetDemoState createState() => _AnimatedWidgetDemoState();
}

class _AnimatedWidgetDemoState extends State<AnimatedWidgetDemo>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 10, end: 60).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            AnimatedLogo(
              animation: animation,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text("forward"),
                  onPressed: () {
                    controller.forward();
                  },
                ),
                FlatButton(
                  child: Text("reverse"),
                  onPressed: () {
                    controller.reverse();
                  },
                ),
              ],
            ),
          ],
        ));
  }
}

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }
}
