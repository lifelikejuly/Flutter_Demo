import 'package:externaltextureplugin_example/demo/texture_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:external_texture_plugin/external_texture_plugin.dart';

import 'mock.dart';

class TextureSingleImageDemo extends StatefulWidget {
  @override
  _TextureDemoState createState() => _TextureDemoState();
}

class _TextureDemoState extends State<TextureSingleImageDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          TextureImageWidget(imgs[0]),
        ],
      ),
    );
  }
}
