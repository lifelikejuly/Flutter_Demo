import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UnderLineIndicatorXX extends Decoration {
  const UnderLineIndicatorXX({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
    this.width = 25,
  })  : assert(borderSide != null),
        assert(insets != null);

  final BorderSide borderSide;

  final EdgeInsetsGeometry insets;

  final double width;

  @override
  _UnderlinePainterXX createBoxPainter([VoidCallback onChanged]) {
    return _UnderlinePainterXX(this, onChanged);
  }
}

class _UnderlinePainterXX extends BoxPainter {
  _UnderlinePainterXX(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final UnderLineIndicatorXX decoration;

  BorderSide get borderSide => decoration.borderSide;

  EdgeInsetsGeometry get insets => decoration.insets;

  double get width => decoration.width;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    //最左边有一个padding 12的起始位置
    offset = Offset(offset.dx, offset.dy);
    //偏移量 + size = 指示器的rect坐标
    final Rect rect = offset & configuration.size;
    final TextDirection textDirection = configuration.textDirection;
    Rect indicator = insets.resolve(textDirection).deflateRect(rect);
//    print(
//        "UnderLineIndicatorX  --rect--- ${rect.toString()} indicator ${indicator.toString()} width ${configuration.size.width}");

    print("-------UnderLineIndicatorX------\n"
        "rect: ${rect.toString()} \n"
        "indicator: ${indicator.toString()} \n"
        "bottomLeft: ${indicator.bottomLeft.toString()} \n"
        "bottomRight: ${indicator.bottomRight.toString()} \n"
        "configuration.size: ${configuration.size.toString()} \n"
        "----------------------\n");
//    double width = configuration.size.width.round() * 1.0;
//    double left = indicator.left + 12;
//    left = left;
//    double right = left + width - 36;
//    right = right;

    double left = indicator.left;
    double right = indicator.right;
    double cw = (left + right) / 2;
    left = cw - width / 2;
    right = width;
    double top = indicator.bottom - borderSide.width;
    double height = borderSide.width;

    indicator = Rect.fromLTWH(left, top, right, height);
    final Paint paint = borderSide.toPaint()..strokeCap = StrokeCap.round;
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);



//    final Paint paint2 = borderSide.toPaint();
//    paint2.color = Colors.orange;
//    Rect cutRect1 = Rect.fromLTWH(indicator.left, top, 10, height);
//    canvas.drawLine(cutRect1.bottomLeft, cutRect1.bottomRight, paint2);
//    Rect cutRect2 =
//        Rect.fromLTWH(indicator.left - 12 + width - 5, top, 5, height);
//    canvas.drawLine(cutRect2.bottomLeft, cutRect2.bottomRight, paint2);

//    print(
//        "UnderLineIndicatorX  --left--- $left --right--- $right ");
  }
}
