import 'package:flutter/material.dart';

class ClippathImageShapeDemo extends StatefulWidget {
  @override
  State<ClippathImageShapeDemo> createState() => _ClippathImageShapeDemoState();
}

class _ClippathImageShapeDemoState extends State<ClippathImageShapeDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Row(
        children: [
          Column(
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
              ClipPath(
                clipper: HeartClipper3(),
                child: Image.network(
                  "https://img0.baidu.com/it/u=2521851051,2189866243&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500",
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              ClipPath(
                clipper: MyPainter(),
                child: Image.network(
                  "https://img0.baidu.com/it/u=2521851051,2189866243&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500",
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      )
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


class HeartClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    size *= 0.9;
    Path path = Path();
    path.lineTo(size.width * 0.53, size.height * 0.26);
    path.cubicTo(size.width * 0.34, size.height * 0.17, size.width / 5, size.height / 5, size.width * 0.13, size.height * 0.35);
    path.cubicTo(size.width * 0.05, size.height * 0.51, size.width * 0.24, size.height * 0.75, size.width * 0.68, size.height);
    path.cubicTo(size.width * 1.09, size.height * 0.56, size.width * 1.21, size.height / 4, size.width * 1.03, size.height * 0.13);
    path.cubicTo(size.width * 0.86, size.height * 0.02, size.width * 0.69, size.height * 0.06, size.width * 0.53, size.height * 0.26);
    path.cubicTo(size.width * 0.53, size.height * 0.26, size.width * 0.53, size.height * 0.26, size.width * 0.53, size.height * 0.26);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class MyPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    Path path = Path();

    paint.color = Color(0xff33455B);
    path = Path();
    path.lineTo(size.width * 0.41, -0.62);
    path.cubicTo(size.width * 0.61, -0.61, size.width * 0.59, -0.4, size.width * 0.69, -0.29);
    path.cubicTo(size.width * 0.74, -0.23, size.width * 0.83, -0.18, size.width * 0.85, -0.11);
    path.cubicTo(size.width * 0.86, -0.03, size.width * 0.81, size.height * 0.04, size.width * 0.75, size.height * 0.11);
    path.cubicTo(size.width * 0.66, size.height / 5, size.width * 0.59, size.height * 0.35, size.width * 0.41, size.height * 0.37);
    path.cubicTo(size.width * 0.22, size.height * 0.4, 0, size.height * 0.35, -0.11, size.height * 0.24);
    path.cubicTo(-0.21, size.height * 0.14, -0.11, size.height * 0.01, -0.06, -0.11);
    path.cubicTo(-0.03, -0.19, size.width * 0.04, -0.24, size.width * 0.1, -0.31);
    path.cubicTo(size.width / 5, -0.42, size.width * 0.22, -0.63, size.width * 0.41, -0.62);
    path.cubicTo(size.width * 0.41, -0.62, size.width * 0.41, -0.62, size.width * 0.41, -0.62);
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}