import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

typedef BigImagesPopCallback = void Function();

typedef BigImagesBuilder<T> = Widget Function(
  BuildContext context, {
  // 是否正在执行动画
  bool widgetMove,
  // 更新需要返回的值
  Function(T) valueUpdate,
  // 关闭时候的rect
  Function(Rect) rectUpdate,
});

typedef BigImagesExtraBuilder = Widget Function(
  BuildContext context, {
  Function popFunc,
});

class BigImagesContainerCopy<T> extends StatefulWidget {
  final BigImagesBuilder<T> builder;

  final BigImagesPopCallback pop;

  final Rect startRect;

  /// 需要pop时候的frame
  final List<Rect> endRectList;

  final BigImagesExtraBuilder extraBuilder;

  BigImagesContainerCopy({
    this.builder,
    this.pop,
    this.startRect,
    this.endRectList,
    this.extraBuilder,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BigImagesContainerState<T>();
}

class BigImagesContainerState<T> extends State<BigImagesContainerCopy<T>>
    with SingleTickerProviderStateMixin {
  /// push和pop动画
  Animation<double> _animation;
  AnimationController _controller;
  AnimationController get controller => _controller;
  // push和pop的动画
  bool _inPushAnimate = false;
  bool _inPopAnimate = false;

  // 拖动
  bool _inDrag = false;
  bool get inDrag => _inDrag;
  double _dragDisX = 0.0;
  double _dragDisY = 0.0;

  // 拖动释放之后的动画
  bool _popAnimateAfterDrag = false;
  bool _resumeAnimateAfterDrag = false;
  double _dargEndTop;
  double _dargEndLeft;
  double _dargEndWidth;
  double _dargEndHeight;
  double _dargEndOpacity;

  T _value;

  Rect _endRect;

  bool get inAnimateOrDrag =>
      (_inPushAnimate ?? false) ||
      (_inPopAnimate ?? false) ||
      (_inDrag ?? false) ||
      (_popAnimateAfterDrag ?? false) ||
      (_resumeAnimateAfterDrag ?? false);

  dynamic updateValue(T value) {
    _value = value;
  }

  dynamic updateRect(Rect rect) {
    _endRect = rect;
  }


  double _screenWidth;
  double _screenHeight;

  @override
  void initState() {
    super.initState();

    _inPushAnimate = true;

    _controller = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _animation = new Tween(begin: 0.0, end: 1.0).animate(_animation)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward().whenCompleteOrCancel(() {
      _inPushAnimate = false;
    });

    _screenWidth = window.physicalSize.width;
    _screenHeight = window.physicalSize.height;

    _screenWidth = _screenWidth / window.devicePixelRatio;
    _screenHeight = _screenHeight / window.devicePixelRatio;
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    _animation = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double opacity = 1;
    Widget child = widget?.builder(
          context,
          widgetMove: inAnimateOrDrag,
          valueUpdate: updateValue,
          rectUpdate: updateRect,
        ) ??
        Container();

    Size bigSize = Size(568, 320);
    if(_screenHeight != null && _screenWidth!= null &&
        _screenWidth != 0 && _screenHeight != 0){
       bigSize = Size(_screenWidth,202);
    }
    if (bigSize.isEmpty) {
      bigSize = Size(568, 320);
    }


    // // 如果没有定位Rect信息 去掉动画效果
    // if(widget.startRect == null ||
    //     widget.startRect == Rect.zero ||
    //     widget.endRectList == null ||
    //     widget.endRectList.length == 0){
    //   List<Widget> children = [];
    //   children.addAll([
    //      Container(color: Colors.black),
    //      child,
    //   ]);
    //
    //   child = Stack(children: children);
    //
    //   if (widget.extraBuilder != null) {
    //     children.add(Opacity(
    //       opacity: opacity == 1.0 ? 1.0 : 0,
    //       child: widget.extraBuilder(context, popFunc: _pop),
    //     ));
    //   }
    //   return Scaffold(
    //     backgroundColor: Colors.transparent,
    //     body: WillPopScope(
    //       onWillPop: _pop,
    //       child: child,
    //     ),
    //   );
    // }


    if ((_inPushAnimate ?? false) || (_inPopAnimate ?? false)) { // 打开和关闭的动画效果
      double animateRadio = _animation.value;

      opacity = animateRadio;

      Rect desRect = _inPushAnimate ? widget.startRect : _calEndRect();
        child = Positioned(
          top: desRect.top * (1 - animateRadio),
          left: desRect.left * (1 - animateRadio),
          width: desRect.width + (bigSize.width - desRect.width) * animateRadio,
          height:
          desRect.height + (bigSize.height - desRect.height) * animateRadio,
          child: child,
        );
    } else if (_inDrag ?? false) { // 拖拽的动画效果

      double dragDisYABS = _dragDisY?.abs() ?? 0;
      double dragRadio = dragDisYABS / (bigSize.height - 50);

      opacity = max(0, min(1 - dragRadio, 1));

      double sizeRadio = 1 - 0.6 * dragRadio;

      _dargEndWidth = bigSize.width * sizeRadio;
      _dargEndHeight = bigSize.height * sizeRadio;
      _dargEndTop = (bigSize.height - _dargEndHeight) / 2 + _dragDisY * 1.1;
      _dargEndLeft = (bigSize.width - _dargEndWidth) / 2 + _dragDisX;
      _dargEndOpacity = opacity;

      child = Positioned(
        top: _dargEndTop,
        left: _dargEndLeft,
        width: _dargEndWidth,
        height: _dargEndHeight,
        child: child,
      );
    } else if (_popAnimateAfterDrag ?? false) { // 拖拽后的关闭动画
      double animateRadio = _animation.value;

      opacity = _dargEndOpacity * animateRadio;

      Rect desRect = _calEndRect();
      child = Positioned(
        top: desRect.top + animateRadio * (_dargEndTop - desRect.top),
        left: desRect.left + animateRadio * (_dargEndLeft - desRect.left),
        width: desRect.width + animateRadio * (_dargEndWidth - desRect.width),
        height:
            desRect.height + animateRadio * (_dargEndHeight - desRect.height),
        child: child,
      );
    } else if (_resumeAnimateAfterDrag ?? false) { // 拖拽后的恢复动画
      double animateRadio = _animation.value;

      opacity = _dargEndOpacity + animateRadio * (1 - _dargEndOpacity);

      child = Positioned(
        top: _dargEndTop + animateRadio * (0 - _dargEndTop),
        left: _dargEndLeft + animateRadio * (0 - _dargEndLeft),
        width: _dargEndWidth + animateRadio * (bigSize.width - _dargEndWidth),
        height:
            _dargEndHeight + animateRadio * (bigSize.height - _dargEndHeight),
        child: child,
      );
    } else {
      double animateRadio = _animation.value;

      opacity = animateRadio;

      Rect desRect = _inPushAnimate ? widget.startRect : _calEndRect();
      child = Positioned(
        top: desRect.top * (1 - animateRadio),
        left: desRect.left * (1 - animateRadio),
        width: desRect.width + (bigSize.width - desRect.width) * animateRadio,
        height:
        desRect.height + (bigSize.height - desRect.height) * animateRadio,
        child: child,
      );
    }

    List<Widget> children = [];
    children.addAll([
      Opacity(
        opacity: opacity,
        child: Container(color: Colors.black),
      ),
      child,
    ]);

    child = Stack(children: children);

    if (widget.extraBuilder != null) {
      children.add(Opacity(
        opacity: opacity == 1.0 ? 1.0 : 0,
        child: widget.extraBuilder(context, popFunc: _pop),
      ));
    }

    /// 手势
    child = _gdWidget(context, child);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        onWillPop: _pop,
        child: child,
      ),
    );
  }

  Rect _calEndRect() {
    if (_endRect == null || _endRect.isEmpty) return widget.startRect;

    ///TODO 如果超出屏幕外，是否重新计算

    return _endRect;
  }

  void _afterDrag() {
    double dragDisYABS = _dragDisY?.abs() ?? 0;
    if (dragDisYABS == 0) {
      return;
    }

    Size bigSize = MediaQuery.of(context).size ?? Size(568, 320);
    if (bigSize.isEmpty) {
      bigSize = Size(568, 320);
    }

    double dragRadio = dragDisYABS / (bigSize.height - 50);
    if (dragRadio >= 0.20) {
      _popAnimateAfterDrag = true;
      _resumeAnimateAfterDrag = false;

      _controller.reverse(from: 1).whenCompleteOrCancel(() {
        if (widget.pop != null) {
          widget.pop();
        }
      });
      // widget?.completer?.complete(_value);
    } else {
      _popAnimateAfterDrag = false;
      _resumeAnimateAfterDrag = true;

      _controller.forward(from: 0).whenCompleteOrCancel(() {
        _resumeAnimateAfterDrag = false;
      });
    }
  }
  // 拖拽方法
  Widget _gdWidget(BuildContext context, Widget child) {
    return Listener(
      onPointerMove: (PointerMoveEvent event) {
        _dragDisX += event.delta.dx;
      },
      child: GestureDetector(
        child: child,
        onTap: () {
          _pop();
        },
        onVerticalDragStart: (DragStartDetails details) {
          // print("<> gesture onVerticalDragStart");
          // 开始
          _inDrag = true;
          _dragDisX = 0.0;
          _dragDisY = 0.0;

          setState(() {});
        },
        onVerticalDragUpdate: (DragUpdateDetails details) {
          // print("<> gesture onVerticalDragUpdate");
          if (_inDrag ?? false) {
            // _dragDisX += details.delta.dx;
            _dragDisY += details.delta.dy;

            setState(() {});
          }
        },
        onVerticalDragEnd: (DragEndDetails details) {
          // print("<> gesture onVerticalDragEnd");
          if (_inDrag ?? false) {
            _inDrag = false;

            _afterDrag();
          }
        },
      ),
    );
  }

  Future<bool> _pop() async {
    if (inAnimateOrDrag) {
      return false;
    }

    _inPopAnimate = true;

    _controller.reverse(from: 1).whenCompleteOrCancel(() {
      if (widget.pop != null) {
        widget.pop();
      }
    });
    // widget?.completer?.complete(_value);

    return false;
  }
}

class ClipPath extends CustomClipper<Path>{
  double scale;


  ClipPath(this.scale);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2 + 10 * scale, 0);
    path.lineTo(size.width /2 + 10 * scale, size.height / 2 + 10* scale);
    path.lineTo(0, size.height / 2 + 10 * scale);
    return path;
  }

  @override
  bool shouldReclip(ClipPath oldClipper) {
    return oldClipper.scale != this.scale;
  }
}
