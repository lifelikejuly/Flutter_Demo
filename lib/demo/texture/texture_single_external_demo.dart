import 'package:flutter/material.dart';
import 'package:external_texture_plugin/external_texture_plugin.dart';
import 'package:flutter_demo/demo/texture/texture_image_widget.dart';

import 'mock.dart';

class TextureSingleExternalImageDemo extends StatefulWidget {
  @override
  _TextureDemoState createState() => _TextureDemoState();
}

class _TextureDemoState extends State<TextureSingleExternalImageDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextureImageWidget(imgs[0]),
            ClipOval(
              child: TextureImageWidget(imgs[0]),
            ),
            _rowScale(),
            SizedBox(
              height: 10,
            ),
            _rowCircle(),
            SizedBox(
              height: 10,
            ),
            ClipPath(
              child: TextureImageWidget(imgs[0],scale: 0.3,),
              clipper: CenterCutClipper(),
            ),
            SizedBox(
              height: 10,
            ),
            _rowRect(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
Widget _rowScale(){
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: <Widget>[
        TextureImageWidget(
          imgs[0],
          scale: 0.2,
        ),
        TextureImageWidget(
          imgs[0],
          scale: 0.2,
        ),
        TextureImageWidget(
          imgs[0],
          scale: 0.2,
        ),
        TextureImageWidget(
          imgs[0],
          scale: 0.2,
        ),
      ],
    ),
  );
}
Widget _rowCircle(){
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: <Widget>[
        ClipPath(
          child: TextureImageWidget(imgs[0],scale: 0.3,),
          clipper: CenterCutClipper(),
        ),
        ClipPath(
          child: TextureImageWidget(imgs[0],scale: 0.3,),
          clipper: CenterCutClipper(),
        ),
        ClipPath(
          child: TextureImageWidget(imgs[0],scale: 0.3,),
          clipper: CenterCutClipper(),
        ),
        ClipPath(
          child: TextureImageWidget(imgs[0],scale: 0.3,),
          clipper: CenterCutClipper(),
        ),
      ],
    ),
  );
}

Widget _rowRect(){
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: <Widget>[
        ClipPath(
          child: TextureImageWidget(
            imgs[0],
            scale: 0.4,
          ),
          clipper: RectClipper(),
        ),
        ClipPath(
          child: TextureImageWidget(
            imgs[0],
            scale: 0.4,
          ),
          clipper: RectClipper(),
        ),
        ClipPath(
          child: TextureImageWidget(
            imgs[0],
            scale: 0.4,
          ),
          clipper: RectClipper(),
        ),
        ClipPath(
          child: TextureImageWidget(
            imgs[0],
            scale: 0.4,
          ),
          clipper: RectClipper(),
        ),
      ],
    ),
  );
}

// center中心圆角裁剪
class CenterCutClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.height / 2))
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// center中心圆角裁剪
class RectClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path()
      ..addRRect(
          RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(10)))
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
