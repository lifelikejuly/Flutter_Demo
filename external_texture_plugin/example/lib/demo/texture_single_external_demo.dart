import 'package:externaltextureplugin_example/demo/texture_image_widget.dart';
import 'package:flutter/material.dart';

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
          ],
        ),
      ),
    );
  }
}
