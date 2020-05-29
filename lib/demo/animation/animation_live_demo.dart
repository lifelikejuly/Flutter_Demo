import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';

class AnimationLiveDemo extends StatefulWidget {
  @override
  _AnimationLiveDemoState createState() => _AnimationLiveDemoState();
}

class _AnimationLiveDemoState extends State<AnimationLiveDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.amber,
        margin: EdgeInsets.only(bottom: 50),
        child: LiveAnimationWidget(),
      ),
    );
  }
}

class LiveAnimationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        LiveAnimationLogo("res/img/love.png"),
        LiveAnimationLogo("res/img/start.png", delayed: 200),
        LiveAnimationLogo("res/img/shopping.png", delayed: 400),
        LiveAnimationLogo("res/img/flower.png", delayed: 600),
        LiveAnimationLogo("res/img/yellow_start.png", delayed: 800),
        LiveAnimationLogo("res/img/wa.png", delayed: 1000),
        Positioned(
          bottom: 0,
          left: (200 - 40) / 2,
          child: Image.asset("res/img/live.png"),
        )
      ],
    );
  }
}

class LiveAnimationLogo extends StatefulWidget {
  final String logoAsset;
  final int delayed;

  LiveAnimationLogo(this.logoAsset, {this.delayed = 0});

  @override
  _LiveAnimationState createState() => _LiveAnimationState();
}

class _LiveAnimationState extends State<LiveAnimationLogo>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  double _value = 1.0;
  double _size = 40;

  //起始位置
  var x0;
  var y0;

  //拐点一
  var x1;
  var y1;

  //拐点二
  var x2;
  var y2;

  //终点位置
  var x3;
  var y3;

  double left = 0;
  double top = 0;
  double angle = 0.0;

  final mWidth = 200.0;
  final mHeight = 300.0;
  final mAngle = math.pi / 10;

  TickerFuture tickerFuture;

  Function _animationListener;

  @override
  void initState() {
    super.initState();
    _initConfigValue();
  }

  _initConfigValue() {
    _initPointValue();
    _animationListener = () {
      if (mounted) {
        setState(() {
          _value = _animation.value;
          var t = (1 - _value);
          left = x0 * math.pow((1 - t), 3) +
              3 * x1 * t * math.pow((1 - t), 2) +
              3 * x2 * math.pow(t, 2) * (1 - t) +
              x3 * math.pow(t, 3);
          top = y0 * math.pow((1 - t), 3) +
              3 * y1 * t * math.pow((1 - t), 2) +
              3 * y2 * math.pow(t, 2) * (1 - t) +
              y3 * math.pow(t, 3);
        });
      }
    };
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear))
      ..addListener(_animationListener);
    _animationController.addStatusListener((status) {
      if (AnimationStatus.completed == status) {
//        print("completed left $left top $top");
        _initPointValue();
        _animationController?.forward(from: 0);
      }
    });
    Future.delayed(Duration(milliseconds: widget.delayed)).then((value) {
      if (mounted) {
        _animationController?.forward();
      }
    });

    print(
        "---------\n _initConfigValue angle $angle \n x0 $x0 y0  $y0 \n x1 $x1 y1  $y1 \n x2 $x2 y2 $y2 \n x3 $x3 y3 $y3 \n ---------");
  }

  _initPointValue() {
    //起始位置
//    var x0 = (mWidth - _size) / 2;
//    var y0 = mHeight - _size;
    x0 = math.Random().nextDouble() * mWidth;
    y0 = mHeight - _size;
    //拐点一
    x1 = math.Random().nextDouble() * mWidth;
    y1 = (mHeight + math.Random().nextDouble() * mHeight) / 2;
    //拐点二
    x2 = math.Random().nextDouble() * mWidth;
    y2 = math.Random().nextDouble() * mHeight / 2;
    //终点位置
    x3 = (mWidth - _size) / 2;
    y3 = -_size;

    var tempValue = math.Random().nextDouble();
    angle = (tempValue < 0.5) ? -tempValue * mAngle : tempValue * mAngle;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: top + _size,
      left: left,
      child: Opacity(
        opacity: (1 - _value),
        child: Transform.rotate(
          angle: angle,
          child: Image.asset(
            widget.logoAsset,
            width: _size * (1 - _value),
            height: _size * (1 - _value),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController?.didUnregisterListener();
    _animationController?.dispose();
    _animation?.removeListener(_animationListener);
    super.dispose();
  }
}
