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
        margin: EdgeInsets.only(bottom: 100, left: 100),
        child: LiveWidget(),
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
        LiveAnimationLogo(
          "res/img/start.png",
          delayed: 200,
          curves: Curves.easeInOutQuad,
        ),
        LiveAnimationLogo(
          "res/img/shopping.png",
          delayed: 400,
          curves: Curves.easeOut,
        ),
        LiveAnimationLogo(
          "res/img/flower.png",
          delayed: 600,
          curves: Curves.easeInOutSine,
        ),
        LiveAnimationLogo(
          "res/img/yellow_start.png",
          delayed: 800,
          curves: Curves.easeOutSine,
        ),
        LiveAnimationLogo(
          "res/img/wa.png",
          delayed: 1000,
          curves: Curves.easeOut,
        ),
        LoveLogo(),
      ],
    );
  }
}

class LiveWidget extends StatefulWidget {
  @override
  _LiveWidgetState createState() => _LiveWidgetState();
}

class _LiveWidgetState extends State<LiveWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        LiveAnimationLogo("res/img/love.png"),
        LiveAnimationLogo(
          "res/img/start.png",
          delayed: 200,
          curves: Curves.easeInOutQuad,
        ),
        LiveAnimationLogo(
          "res/img/shopping.png",
          delayed: 400,
          curves: Curves.easeOut,
        ),
        LiveAnimationLogo(
          "res/img/flower.png",
          delayed: 600,
          curves: Curves.easeInOutSine,
        ),
        LiveAnimationLogo(
          "res/img/yellow_start.png",
          delayed: 800,
          curves: Curves.easeOutSine,
        ),
        LiveAnimationLogo(
          "res/img/wa.png",
          delayed: 1000,
          curves: Curves.easeOut,
        ),
        LoveLogo(),
      ],
    );
  }
}

const double logoSize = 20 * 2.0;
const double mWidth = 40 * 2.0;
const double mHeight = 75 * 2.0;
const mAngle = math.pi / 10;

class LoveLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: (mWidth - logoSize) / 2,
      child: Image.asset(
        "res/img/live.png",
        width: logoSize,
        height: logoSize,
      ),
    );
  }
}

class LiveAnimationLogo extends StatefulWidget {
  final String logoAsset;
  final int delayed;
  final Curve curves;

  LiveAnimationLogo(this.logoAsset,
      {this.delayed = 0, this.curves = Curves.linear});

  @override
  _LiveAnimationState createState() => _LiveAnimationState();
}

class _LiveAnimationState extends State<LiveAnimationLogo>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  double _value = 1.0;

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
  int startTime = 0;

  TickerFuture tickerFuture;

  Function _animationListener;

  @override
  void initState() {
    super.initState();
    print("animation ----initState---- logoAsset ${widget.logoAsset}");
    _initPointValue();
    _initConfigValue();
  }

  /// 初始化参数
  _initConfigValue() {
    _animationListener = () {
      if (mounted) {
        setState(() {
          _calSebelValue();
        });
      }
    };
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: widget.curves))
      ..addListener(_animationListener);
    _animationController.addStatusListener((status) {
      if (AnimationStatus.completed == status) {
        _initPointValue();
        //为了避免多个logo动画同时执行（切换页面或是应用切到后台时会出现）
        if (DateTime.now().millisecondsSinceEpoch - startTime > 1100) {
          _delayStartAnimation();
        } else {
          _animationController?.forward(from: 0);
          startTime = DateTime.now().millisecondsSinceEpoch;
        }
      }
    });
    _delayStartAnimation();
//    print(
//        "---------\n _initConfigValue angle $angle \n x0 $x0 y0  $y0 \n x1 $x1 y1  $y1 \n x2 $x2 y2 $y2 \n x3 $x3 y3 $y3 \n ---------");
  }

  /// 初始化坐标点参数
  _initPointValue() {
    //起始位置
    x0 = math.Random().nextDouble() * mWidth;
    y0 = mHeight - logoSize;
    //拐点一
    x1 = math.Random().nextDouble() * mWidth;
    y1 = (mHeight + math.Random().nextDouble() * mHeight) / 2;
    //拐点二
    x2 = math.Random().nextDouble() * mWidth;
    y2 = math.Random().nextDouble() * mHeight / 2;
    //终点位置
    x3 = (mWidth - logoSize) / 2;
    y3 = -logoSize;

    var tempValue = math.Random().nextDouble();
    angle = (tempValue < 0.5) ? -tempValue * mAngle : tempValue * mAngle;
  }

  /// 塞贝尔曲线动画轨迹坐标计算
  _calSebelValue() {
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
  }

  /// 延后开始动画执行
  _delayStartAnimation() {
    Future.delayed(Duration(milliseconds: widget.delayed)).then((value) {
      if (mounted) {
        _animationController?.forward(from: 0);
        startTime = DateTime.now().millisecondsSinceEpoch;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = 1 - _value;
    return Positioned(
      bottom: top + logoSize,
      left: left,
      child: Opacity(
        opacity: size,
        child: Transform.rotate(
          angle: angle,
          child: Image.asset(
            widget.logoAsset,
            width: logoSize * size,
            height: logoSize * size,
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
    print("animation ----dispose---- logoAsset ${widget.logoAsset}");
  }

  @override
  void deactivate() {
    print("animation ----deactivate---- logoAsset ${widget.logoAsset}");
    super.deactivate();
  }
}
