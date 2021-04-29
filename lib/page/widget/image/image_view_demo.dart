

import 'package:flutter/material.dart';

class ImageViewDemo extends StatefulWidget {
  @override
  _ImageViewDemoState createState() => _ImageViewDemoState();
}

class _ImageViewDemoState extends State<ImageViewDemo> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        // webp类型图片不支持旋转
        Image.asset("images/bigimage.jpeg"),
        Image.asset("images/bigimage.webp"),
      ],
    );
  }
}
