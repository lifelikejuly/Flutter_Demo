import 'package:flutter/material.dart';


class CanvasCircleDemo extends StatefulWidget {
  @override
  _CanvasCircleDemoState createState() => _CanvasCircleDemoState();
}

class _CanvasCircleDemoState extends State<CanvasCircleDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: CirclePainter(),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  Color green = Color(0xFF2BF6EE);
  Color red = Color(0xFFFB1354);

  CirclePainter();

  static final double _ellipseControlPointPercentage = 0.551915024494;

  final Path _path = Path();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.restore();

    Offset offset = Offset(100, 100);
    var halfWidth = offset.dx / 2.0;
    var halfHeight = offset.dy / 2.0;
    // TODO: handle bounds

    var cpW = halfWidth * _ellipseControlPointPercentage;
    var cpH = halfHeight * _ellipseControlPointPercentage;

    _path.reset();
    _path.moveTo(0, -halfHeight);
    _path.cubicTo(0 + cpW, -halfHeight, halfWidth, 0 - cpH, halfWidth, 0);
    _path.cubicTo(halfWidth, 0 + cpH, 0 + cpW, halfHeight, 0, halfHeight);
    _path.cubicTo(0 - cpW, halfHeight, -halfWidth, 0 + cpH, -halfWidth, 0);
    _path.cubicTo(-halfWidth, 0 - cpH, 0 - cpW, -halfHeight, 0, -halfHeight);
    _path.offset(Offset(200, 200));
    _path.close();
    canvas.drawPath(_path, Paint()..color = green);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}

extension PathExtension on Path {
  void set(Path path) {
    reset();
    addPath(path, Offset.zero);
  }

  void offset(Offset offset) {
    set(shift(offset));
  }
}