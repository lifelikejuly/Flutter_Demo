import 'package:externaltextureplugin_example/demo/mock.dart';
import 'package:externaltextureplugin_example/demo/texture_image_widget.dart';
import 'package:flutter/material.dart';

class TextureListDemo extends StatefulWidget {
  @override
  _TextureDemoState createState() => _TextureDemoState();
}

class _TextureDemoState extends State<TextureListDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return TextureImageWidget(imgs[index % imgs.length]);
        },
        itemCount: 300,
      ),
    );
  }
}
