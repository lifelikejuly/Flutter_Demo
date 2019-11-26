import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

enum DragDirection { top, right, left, bottom }

class DrawerPanGestureRecognizer extends PanGestureRecognizer {}

class DragDrawerView extends StatefulWidget {
  /// 内容子组件
  final Widget child;

  /// 初始偏移值
  final double initOffset;

  /// 拖拽方向
  final DragDirection direction;

  /// 父视图宽
  final double parentWidth;

  /// 父视图高
  final double parentHeight;

  DragDrawerView(this.child,
      {this.initOffset = 10,
      this.direction = DragDirection.left,
      this.parentWidth = 0,
      this.parentHeight = 0});

  @override
  _DragDrawerViewState createState() => _DragDrawerViewState();
}

class _DragDrawerViewState extends State<DragDrawerView>
    with TickerProviderStateMixin {
  AnimationController _resetAnimationController;
  AnimationController _forwarAnimationController;
  Animation _animation;

  double offsetY = 0;
  double offsetX = 0;
  DragDirection direction;

  @override
  void initState() {
    super.initState();
    /// 初始化数据
    direction = widget.direction;

    _resetAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _forwarAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
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
                ..onStart = (DragStartDetails details) {}
                ..onUpdate = (DragUpdateDetails details) {}
                ..onEnd = (DragEndDetails details) {};
            },
          ),
        },
        child: widget.child,
      ),
    );
  }

  _forwardAnimation() {
    double beginOffset = 0;
    double endOffset = 0;
    _animation = Tween<double>(begin: beginOffset, end: endOffset).animate(
        CurvedAnimation(
            parent: _forwarAnimationController, curve: Curves.easeOut))
      ..addListener(() {});
  }

  _resetAnimation() {
    double beginOffset = 0;
    double endOffset = 0;
    _animation = Tween<double>(begin: beginOffset, end: endOffset).animate(
        CurvedAnimation(
            parent: _resetAnimationController, curve: Curves.easeOut))
      ..addListener(() {});
  }
}
