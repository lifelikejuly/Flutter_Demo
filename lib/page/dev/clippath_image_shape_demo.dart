import 'package:flutter/material.dart';

class ClippathImageShapeDemo extends StatefulWidget {
  @override
  State<ClippathImageShapeDemo> createState() => _ClippathImageShapeDemoState();
}

class _ClippathImageShapeDemoState extends State<ClippathImageShapeDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.yellow,
      child: Column(
        children: [
          ClipPath(
            clipper: HeartClipper(),
            child: Image.network(
              "https://img0.baidu.com/it/u=2521851051,2189866243&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500",
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          ClipPath(
            clipper: HeartClipper2(),
            child: Image.network(
              "https://img0.baidu.com/it/u=2521851051,2189866243&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500",
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class HeartClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = 150;
    double height = 150;
    Path path = Path();
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.2 * width, height * 0.1, -0.25 * width, height * 0.6,
        0.5 * width, height);
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.8 * width, height * 0.1, 1.25 * width, height * 0.6,
        0.5 * width, height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}


class HeartClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = 150;
    double height = 150;
    Path path = Path();
    path.moveTo(0.45 * width, height * 0.5);
    path.cubicTo(0.45 * width, height * 0.5, -0.25 * width, height * 0.6,
        0.7 * width, height);

    path.moveTo(0.45 * width, height * 0.5);
    path.cubicTo(0.55 * width, height * 0.05, 1.0 * width, height * 0.6,
        0.7 * width, height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}