import 'dart:math';

import 'package:flutter/material.dart';

class FlipNumText extends StatefulWidget {
  final int num;
  final int maxNum;

  FlipNumText(this.num, this.maxNum);

  @override
  _FlipNumTextState createState() => _FlipNumTextState();
}

class _FlipNumTextState extends State<FlipNumText>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  bool _isReversePhase = false;

  double _zeroAngle = 0.0001;

  int _stateNum = 0;

  @override
  void initState() {
    super.initState();
    print("initState");
    _stateNum = widget.num;

    ///动画控制器，正向执行一次后再反向执行一次每次时间为450ms。
    _controller = new AnimationController(
        duration: Duration(milliseconds: 450), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          ///正向动画执行结束后，反向动画执行标志位设置true 进行反向动画执行
          _controller.reverse();
          _isReversePhase = true;
//          print("AnimationStatus.completed");
        }
        if (status == AnimationStatus.dismissed) {
          ///反向动画执行结束后，反向动画执行标志位false 将当前数值加一更改为动画后的值
          _isReversePhase = false;
          _calNum();
//          print("AnimationStatus.dismissed");
        }
      })
      ..addListener(() {
        setState(() {});
      });

    ///四分之一的圆弧长度
    _animation = Tween(begin: _zeroAngle, end: pi / 2).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    Color _color = Colors.white;
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: <Widget>[
              ClipRectText(_nextNum(), Alignment.topCenter, _color),

              ///动画正向执行翻转的组件
              Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.006)
                    ..rotateX(_isReversePhase ? pi / 2 : _animation.value),
                  alignment: Alignment.bottomCenter,
                  child: ClipRectText(_stateNum, Alignment.topCenter, _color)),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.0),
          ),
          Stack(
            children: <Widget>[
              ClipRectText(_stateNum, Alignment.bottomCenter, _color),

              ///动画反向执行翻转的组件
              Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.006)
                    ..rotateX(_isReversePhase ? -_animation.value : pi / 2),
                  alignment: Alignment.topCenter,
                  child:
                      ClipRectText(_nextNum(), Alignment.bottomCenter, _color)),
            ],
          )
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(FlipNumText oldWidget) {
    if (this.widget.num != oldWidget.num) {
      _controller.forward();
      _stateNum = oldWidget.num;
    }
    super.didUpdateWidget(oldWidget);
  }

  _nextNum() {
    if (_stateNum == widget.maxNum) {
      return 0;
    } else {
      return _stateNum + 1;
    }
  }

  _calNum() {
    if (_stateNum == widget.maxNum) {
      _stateNum = 0;
    } else {
      _stateNum += 1;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
    }
  }
}

class ClipRectText extends StatelessWidget {
  final int _value;
  final Alignment _alignment;
  final Color _color;

  ClipRectText(this._value, this._alignment, this._color);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width / 5 + 10;
    return ClipRect(
      child: Align(
        alignment: _alignment,
        heightFactor: 0.5,
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          alignment: Alignment.center,
          width: width,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          child: Text(
            "$_value",
            style: TextStyle(
              fontFamily: "Din",
              fontSize: width - 30,
              color: _color,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
