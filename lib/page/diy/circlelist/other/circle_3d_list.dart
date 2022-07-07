import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/page/diy/circlelist/other/radialdrag_gesturedetector.dart';


class Circle3DList extends StatefulWidget {
  final double innerRadius;
  final double outerRadius;
  final double childrenPadding;
  final double initialAngle;
  final Color outerCircleColor;
  final Color innerCircleColor;
  final Gradient gradient;
  final List<Widget> children;
  final bool isChildrenVertical;
  final RotateMode rotateMode;
  final bool innerCircleRotateWithChildren;
  final bool showInitialAnimation;
  final Widget centerWidget;
  final RadialDragStart onDragStart;
  final RadialDragUpdate onDragUpdate;
  final RadialDragEnd onDragEnd;
  final AnimationSetting animationSetting;
  final DragAngleRange dragAngleRange;

  Circle3DList({
    this.innerRadius,
    this.outerRadius,
    this.childrenPadding = 10,
    this.initialAngle = 0,
    this.outerCircleColor,
    this.innerCircleColor,
    @required this.children,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.gradient,
    this.centerWidget,
    this.isChildrenVertical = true,
    this.innerCircleRotateWithChildren = false,
    this.showInitialAnimation = false,
    this.animationSetting,
    this.rotateMode,
    this.dragAngleRange,
  });

  @override
  _CircleListState createState() => _CircleListState();
}

class _CircleListState extends State<Circle3DList>
    with SingleTickerProviderStateMixin {
  _DragModel dragModel = _DragModel();
  AnimationController _controller;
  Animation<double> _animationRotate;
  bool isAnimationStop = true;


  double initAngle;
  double centerAngle;

  @override
  void initState() {
    if (widget.showInitialAnimation) {
      _controller = AnimationController(
          vsync: this,
          duration: widget.animationSetting?.duration ?? Duration(seconds: 1));
      _animationRotate = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _controller,
          curve: widget.animationSetting?.curve ?? Curves.easeOutBack));
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            isAnimationStop = true;
          });
        }
      });
      _controller.addListener(() {
        setState(() {
          isAnimationStop = false;
        });
      });
      _controller.forward();
    }
    super.initState();
    initAngle =  dragModel.angleDiff + widget.initialAngle;
    centerAngle = initAngle + pi;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  // 缩放逻辑
  double _scale(double newAngle){
    double scale = 1.0;
    if(newAngle >= 0 && newAngle < pi){
      scale = (pi - newAngle) / pi * 0.5 + 0.5;
    }else if(newAngle >= pi && newAngle < pi * 2){
      scale = (newAngle - pi * 2 ) / pi * 0.5 + 1.0;
    }else if(newAngle > pi * 2){
      scale = _scale(newAngle - pi * 2);
    }
    return scale;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final outCircleDiameter = min(size.width, size.height);
    final double outerRadius = widget.outerRadius ?? outCircleDiameter / 2;
    final double innerRadius = widget.innerRadius ?? outerRadius / 2;
    final double betweenRadius = (outerRadius + innerRadius) / 2;
    final rotateMode = widget.rotateMode ?? RotateMode.onlyChildrenRotate;
    final dragAngleRange = widget.dragAngleRange;

    Widget child = Stack(
        children: List.generate(widget.children.length, (index) {
      final double childrenDiameter =
          2 * pi * betweenRadius / widget.children.length -
              widget.childrenPadding;
      // 偏移计算
      Offset childPoint = getChildPoint(
          index,
          widget.children.length,
          betweenRadius,
          childrenDiameter);
      double angle =  2 * pi / widget.children.length * index;
      double newAngle = dragModel.angleDiff + angle;

      double scale = _scale(newAngle);

      // 对象
      Widget child2 = Container(
          width: childrenDiameter,
          height: childrenDiameter,
          alignment: Alignment.center,
          child: widget.children[index]);
      // 旋转和缩放
      // Transform transform1 =  Transform.scale(
      //   scale: scale,
      //   // angle: widget.isChildrenVertical
      //   //     ? (-(dragModel.angleDiff) - widget.initialAngle)
      //   //     : ((dragModel.angleDiff) + widget.initialAngle),
      //   child: child2
      // );

      double transformAngle = widget.isChildrenVertical
          ? (-(dragModel.angleDiff) - widget.initialAngle)
          : ((dragModel.angleDiff) + widget.initialAngle);
      Matrix4 matrix4 = Matrix4.identity();
      matrix4.scale(scale);
      matrix4.rotateZ(transformAngle);
      Transform transform1 = Transform(
          alignment: Alignment.center,
          transform: matrix4,
          child: child2
      );

      //定位
      return Positioned(
        left: outerRadius + childPoint.dx,
        top: outerRadius + childPoint.dy,
        child:transform1,
      );
    }),
    );


    Transform transform =  Transform.rotate(
      angle:(dragModel.angleDiff + widget.initialAngle),
      child: child
    );
    // transform.transform.setRotationY(10.0);
    return Container(
      width: outerRadius * 2,
      height: outerRadius * 2,
      child:  Container(
              width: outerRadius * 2,
              height: outerRadius * 2,
              child: RadialDragGestureDetector(
                stopRotate: rotateMode == RotateMode.stopRotate,
                onRadialDragUpdate: (PolarCoord updateCoord) {
                  if (widget.onDragUpdate != null) {
                    widget.onDragUpdate(updateCoord);
                  }
                  setState(() {
                    dragModel.getAngleDiff(updateCoord, dragAngleRange);
                  });
                },
                onRadialDragStart: (PolarCoord startCoord) {
                  if (widget.onDragStart != null) {
                    widget.onDragStart(startCoord);
                  }
                  setState(() {
                    dragModel.start = startCoord;
                  });
                },
                onRadialDragEnd: () {
                  if (widget.onDragEnd != null) {
                    widget.onDragEnd();
                  }
                  dragModel.end = dragModel.start;
                  dragModel.end.angle = dragModel.angleDiff;
                },
                child: transform
              ),
            ),
          );
  }

  Offset getChildPoint(
      int index, int length, double betweenRadius, double childrenDiameter) {
    double angel = 2 * pi * (index / length);
    double x =  0.85 * cos(angel) * betweenRadius - childrenDiameter / 2;
    double y = 0.85 * sin(angel) * betweenRadius - childrenDiameter / 2 ;

    return Offset(x, y);
  }
}

class _DragModel {
  PolarCoord start;
  PolarCoord end;
  double angleDiff = 0.0;

  double getAngleDiff(PolarCoord updatePolar, DragAngleRange dragAngleRange) {
    if (start != null) {
      angleDiff = updatePolar.angle - start.angle;
      if (end != null) {
        angleDiff += end.angle;
      }
    }
    angleDiff = limitAngle(angleDiff, dragAngleRange);
    return angleDiff;
  }

  double limitAngle(double angleDiff, DragAngleRange dragAngleRange) {
    if (dragAngleRange == null) return angleDiff;
    if (angleDiff > dragAngleRange.end) angleDiff = dragAngleRange.end;
    if (angleDiff < dragAngleRange.start) angleDiff = dragAngleRange.start;
    return angleDiff;
  }
}

class AnimationSetting {
  final Duration duration;
  final Curve curve;

  AnimationSetting({this.duration, this.curve});
}