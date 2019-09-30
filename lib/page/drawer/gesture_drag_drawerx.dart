import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum DragDirection { top, right, left, bottom }

class GestureDragDrawer extends StatefulWidget {
  final Widget child;

  /// 子视图大小
  final double childSize;

  ///偏移量
  final double originOffset;

  ///拖拽方向
  final DragDirection direction;

  final double parentWidth;
  final double parentHeight;

  GestureDragDrawer(
      {this.child,
      this.childSize = 0,
      this.originOffset = 0,
      this.parentWidth = 0,
      this.parentHeight = 0,
      this.direction = DragDirection.left});

  @override
  _GestureDragDrawerState createState() => _GestureDragDrawerState();
}

class _GestureDragDrawerState extends State<GestureDragDrawer>
    with TickerProviderStateMixin {
  /// 初始化状态:设置宽度、起始偏移量、最小偏移量、中间偏移量、最大偏移量
  _initValue() {
    width = widget.childSize.abs();
    minOffset = -width / 2;
    midOffset = -width / 3;
    maxOffset = 0;
    /// 底部和右边的偏移量需要特殊计算初始值
    switch (widget.direction) {
      case DragDirection.bottom:
        originOffset = widget.parentHeight - widget.originOffset;
        maxOffset = widget.parentHeight - width;
        midOffset = maxOffset + width / 3;
        minOffset = maxOffset + width / 2;
        break;
      case DragDirection.right:
        originOffset = widget.parentWidth - widget.originOffset;
        maxOffset = widget.parentWidth - width;
        midOffset = maxOffset + width / 3;
        minOffset = maxOffset + width / 2;
        break;
      default:
        originOffset = -width + widget.originOffset;
        break;
    }
    print(
        "dragdemo minOffset: $minOffset  midOffset: $midOffset  maxOffset: $maxOffset");
  }

  /// 复原动画
  _setCallBackAnimation() {
    double offset;
    switch (widget.direction) {
      case DragDirection.top:
      case DragDirection.bottom:
        offset = offsetY;
        break;
      case DragDirection.left:
      case DragDirection.right:
        offset = offsetX;
        break;
    }
    print("dragdemo _setCallBackAnimation  begin: $offset, end: $originOffset");
    _animation = Tween<double>(begin: offset, end: originOffset).animate(
        CurvedAnimation(
            parent: _callbackAnimationController, curve: Curves.easeOut))
      ..addListener(() {
        print("dragdemo _setCallBackAnimation  ${_animation.value}");
        setState(() {
          switch (widget.direction) {
            case DragDirection.top:
            case DragDirection.bottom:
              offsetY = _animation.value;
              break;
            case DragDirection.left:
            case DragDirection.right:
              offsetX = _animation.value;
              break;
          }
        });
      });
  }

  /// 展开动画
  _setToMaxAnimation() {
    double offset;
    switch (widget.direction) {
      case DragDirection.top:
      case DragDirection.bottom:
        offset = offsetY;
        break;
      case DragDirection.left:
      case DragDirection.right:
        offset = offsetX;
        break;
    }
    print("dragdemo _setToMaxAnimation  begin: $offset, end: $maxOffset");
    _animation = Tween<double>(begin: offset, end: maxOffset).animate(
        CurvedAnimation(
            parent: _toMaxAnimationController, curve: Curves.easeOutQuart))
      ..addListener(() {
        print("dragdemo _setToMaxAnimation    ${_animation.value}");
        setState(() {
          switch (widget.direction) {
            case DragDirection.top:
            case DragDirection.bottom:
              offsetY = _animation.value;
              break;
            case DragDirection.left:
            case DragDirection.right:
              offsetX = _animation.value;
              break;
          }
        });
      });
  }

  ///展开最大值
  double maxOffset = 300;

  ///偏移量中间值
  double midOffset = 250;

  double minOffset = 200;

  double width;

  double originOffset = -100;

  double offsetY = 0;
  double offsetX = 0;

  AnimationController _callbackAnimationController;
  AnimationController _toMaxAnimationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _initValue();
    _callbackAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _toMaxAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    switch (widget.direction) {
      case DragDirection.top:
        offsetY = originOffset;
        break;
      case DragDirection.bottom:
        offsetY = originOffset;
        break;
      case DragDirection.left:
        offsetX = originOffset;
        break;
      case DragDirection.right:
        offsetX = originOffset;
        break;
    }
    print("dragdemo offsetY $offsetY offsetX $offsetX");
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(offsetX, offsetY),
      child: RawGestureDetector(
        gestures: {
          DrawerPanGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<DrawerPanGestureRecognizer>(
            () => DrawerPanGestureRecognizer(),
            (DrawerPanGestureRecognizer instance) {
              instance
                ..onUpdate = (DragUpdateDetails details) {
                  switch (widget.direction) {
                    case DragDirection.top:
                      if (offsetY <= maxOffset) {
                        setState(() {
                          offsetY = offsetY + details.delta.dy;
                        });
                      }
                      break;
                    case DragDirection.bottom:
                      if (offsetY >= maxOffset) {
                        setState(() {
                          offsetY = offsetY + details.delta.dy;
                        });
                      }
                      break;
                    case DragDirection.left:
                      if (offsetX <= maxOffset) {
                        setState(() {
                          offsetX = offsetX + details.delta.dx;
                        });
                      }
                      break;
                    case DragDirection.right:
                      if (offsetX >= maxOffset) {
                        setState(() {
                          offsetX = offsetX + details.delta.dx;
                        });
                      }
                      break;
                  }
                }
                ..onEnd = (DragEndDetails details) {
                  print(
                      "dragdemo onend minOffset $minOffset - offsetX $offsetX - offsetY $offsetY");
                  switch (widget.direction) {
                    case DragDirection.top:
                      if (offsetY < minOffset) {
                        _setCallBackAnimation();
                        _callbackAnimationController.forward(from: offsetY);
                      } else if (offsetY > minOffset) {
                        _setToMaxAnimation();
                        _toMaxAnimationController.forward(from: offsetY);
                      }
                      break;
                    case DragDirection.bottom:
                      if (offsetY > minOffset) {
                        _setCallBackAnimation();
                        _callbackAnimationController.reset();
                        _callbackAnimationController.forward();
                      } else if (offsetY < minOffset) {
                        _setToMaxAnimation();
                        _toMaxAnimationController.reset();
                        _toMaxAnimationController.forward();
                      }
                      break;
                    case DragDirection.left:
                      if (offsetX < minOffset) {
                        _setCallBackAnimation();
                        _callbackAnimationController.forward(from: offsetX);
                      } else if (offsetX > minOffset) {
                        _setToMaxAnimation();
                        _toMaxAnimationController.forward(from: offsetX);
                      }
                      break;
                    case DragDirection.right:
                      if (offsetX > minOffset) {
                        _setCallBackAnimation();
                        _callbackAnimationController.reset();
                        _callbackAnimationController.forward();
                      } else if (offsetX < minOffset) {
                        _setToMaxAnimation();
                        _toMaxAnimationController.reset();
                        _toMaxAnimationController.forward();
                      }
                      break;
                  }
                };
            },
          ),
        },
        child: Container(
          width: width,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_callbackAnimationController != null) {
      _callbackAnimationController.dispose();
    }
    if (_toMaxAnimationController != null) {
      _toMaxAnimationController.dispose();
    }
  }
}

class DrawerPanGestureRecognizer extends PanGestureRecognizer {}
