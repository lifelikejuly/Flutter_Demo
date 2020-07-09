import 'package:externaltextureplugin_example/demo/mock.dart';
import 'package:flutter/material.dart';

import 'NetworkImageWithoutAuth.dart';
import 'fade_in_iamge.dart';

class ImageListDemo extends StatefulWidget {
  @override
  _FlutterImageDemoState createState() => _FlutterImageDemoState();
}

class _FlutterImageDemoState extends State<ImageListDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Image 加载"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return FadeInImageWithoutAuth.assetNetwork(
            placeholder: "res/img/jay.jpg",
            image: imgs[index % imgs.length],
            fit: BoxFit.fill,
          );
        },
        itemCount: 300,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    PaintingBinding.instance.imageCache.clear();
  }
}
