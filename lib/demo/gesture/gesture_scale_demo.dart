import 'package:flutter/material.dart';

class GestureScaleDemo extends StatefulWidget {
  @override
  _GestureScaleDemoState createState() => _GestureScaleDemoState();
}

class _GestureScaleDemoState extends State<GestureScaleDemo> {
  double scale = 1.0;
  double rotation = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: GestureDetector(
            child: Transform(
              origin: Offset(size.width / 2, size.height / 2),
              transform: Matrix4.rotationZ(rotation).scaled(scale),
              child: Image.asset("res/img/jay.jpg"),
            ),
            onScaleStart: (scaleStartDetail) {},
            onScaleUpdate: (scaleUpdateDetail) {
              scale = scaleUpdateDetail.scale;
              rotation = scaleUpdateDetail.rotation;
              setState(() {});
            },
            onScaleEnd: (scaleEndDetail) {},
          ),
        ),
      ),
    );
  }
}
