import 'package:external_texture_plugin/external_texture_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Demo测试使用
class TextureImageWidget extends StatefulWidget {
  final String url;
  double scale;

  TextureImageWidget(this.url, {this.scale = 1.0});

  @override
  _TextureImageWidgetState createState() => _TextureImageWidgetState();
}

class _TextureImageWidgetState extends State<TextureImageWidget> {
  int textureId;
  int width;
  int height;

  @override
  void initState() {
    super.initState();
    _loadTextureId();
  }

  _loadTextureId() async {
    var response = await ExternalTexturePlugin.loadImg(widget.url);
    if (response != null && response["textureId"] != null) {
      textureId = response["textureId"];
      width = response["width"];
      height = response["height"];
      print("TextureImageWidget _loadTextureId textureId $textureId width $width height $height");
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return textureId != null
        ? Container(
            width: width * widget.scale,
            child: AspectRatio(
              aspectRatio: width / height,
              child: Texture(textureId: textureId),
            ),
          )
        : SizedBox(
            height: 200,
          );
  }

  @override
  void dispose() {
    _release();
    print("TextureImageWidget dispose textureId $textureId");
    super.dispose();
  }

  _release() async {
    await ExternalTexturePlugin.release(widget.url);
  }
}
