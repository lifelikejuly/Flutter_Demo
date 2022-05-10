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
        Image.asset("images/bigimage.jpeg",height: 100,),
        Image.asset("images/bigimage.webp",height: 100,),
        Image.network(
          "https://cdn-sqn.aigei.com/assets/site/img/tool/demo-bgremover-new.png",
          color: Colors.black,
          height: 100,
        ),
        Image.network(
          "https://cdn-sqn.aigei.com/assets/site/img/tool/demo-bgremover-new.png",
          height: 100,
        ),
      ],
    );
  }
}
