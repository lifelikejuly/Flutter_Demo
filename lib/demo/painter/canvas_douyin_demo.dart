import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class CanvasDouyinDemo extends StatefulWidget {
  @override
  _CanvasDouyinDemoState createState() => _CanvasDouyinDemoState();
}

class _CanvasDouyinDemoState extends State<CanvasDouyinDemo> {
  double dx = 200;
  double dy = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: CustomPaint(
          painter: DouyinPainter(dx, dy),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
//    Timer.periodic(Duration(milliseconds: 500), (timer) {
//      int next = Random().nextInt(5);
//      setState(() {
//        dy = dx = 100.0 + next;
//      });
//    });
  }
}

class DouyinPainter extends CustomPainter {
  Color green = Color(0xFF2BF6EE);
  Color red = Color(0xFFFB1354);
  double dx = 100;
  double dy = 100;

  DouyinPainter(this.dx, this.dy);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.restore();
    Paint paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 10;
    paint.color = green;
    _drawJ(Offset(dx, dy), canvas, paint);
    paint.color = red;
    paint.blendMode = BlendMode.colorDodge;
    _drawJ(Offset(dx + 3, dy + 5), canvas, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  _drawJ(Offset offset, Canvas canvas, Paint paint) {
    canvas.drawArc(
        Rect.fromCircle(
          center: offset,
          radius: 15,
        ),
        0,
        270 * (pi / 180),
        false,
        paint);
    canvas.drawLine(
      Offset(offset.dx + 15, offset.dy - 40),
      Offset(offset.dx + 15, offset.dy),
      paint,
    );
    canvas.drawArc(
        Rect.fromCircle(
          center: Offset(
            offset.dx + 30,
            offset.dy - 40,
          ),
          radius: 15,
        ),
        90 * (pi / 180),
        90 * (pi / 180),
        false,
        paint);
  }
}
