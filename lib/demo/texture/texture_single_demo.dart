import 'package:flutter/material.dart';
import 'package:flutter_app_plugin/flutter_app_plugin.dart';

class TextureListDemo extends StatefulWidget {
  @override
  _TextureDemoState createState() => _TextureDemoState();
}

class _TextureDemoState extends State<TextureListDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          TextureTemp(),

        ],
      ),
    );
  }
}

class TextureTemp extends StatefulWidget {
  @override
  _TextureTempState createState() => _TextureTempState();
}

class _TextureTempState extends State<TextureTemp> {
  int textureId;

  @override
  void initState() {
    super.initState();
    _loadTextureId();
  }

  _loadTextureId() async {
    var response = await FlutterAppPlugin.loadTextureId();
    textureId = response["textureId"];
    await FlutterAppPlugin.loadTextureImg(textureId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return textureId != null
        ? Container(
            child: Container(
              height: 100,
              width: 100,
              child: Texture(textureId: textureId),
            ),
          )
        : SizedBox();
  }
}
