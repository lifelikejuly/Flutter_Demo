import 'package:external_texture_plugin/external_texture_plugin.dart';
import 'package:externaltextureplugin_example/demo/texture_image_widget.dart';
import 'package:flutter/material.dart';

import 'mock.dart';

class TextureGridListDemo extends StatefulWidget {
  @override
  _TextureDemoState createState() => _TextureDemoState();
}

class _TextureDemoState extends State<TextureGridListDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return TextureImageWidget(imgs[index % imgs.length]);
        },
        itemCount: 300,
      ),
    );
  }
}
