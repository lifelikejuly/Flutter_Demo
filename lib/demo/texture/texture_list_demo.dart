import 'package:external_texture_plugin/external_texture_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/demo/texture/mock.dart';

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
          return TextureTemp(index);
        },
        itemCount: 300,
      ),
    );
  }
}

class TextureTemp extends StatefulWidget {
  final int num;

  TextureTemp(this.num);

  @override
  _TextureTempState createState() => _TextureTempState();
}

class _TextureTempState extends State<TextureTemp> {
  int textureId;
  int width;
  int height;

  @override
  void initState() {
    super.initState();
    _loadTextureId();
  }

  _loadTextureId() async {
    var response =
        await ExternalTexturePlugin.loadImg(imgs[widget.num % imgs.length]);
    if (response != null && response["textureId"] != null) {
      textureId = response["textureId"];
      width = response["width"];
      height = response["height"];
      print(
          "_TextureTempState -- num: ${widget.num} -- textureId:${textureId.toString()}");

      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
   _releaseTexture();
  }
  _releaseTexture() async{
    var response =
    await ExternalTexturePlugin.release(imgs[widget.num % imgs.length]);
    print("_TextureTempState -- dispose num: ${widget.num} $response");
  }

  @override
  Widget build(BuildContext context) {
    return textureId != null
        ? Container(
            child: Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio:
                      (width?.toDouble() ?? 0) / (height?.toDouble() ?? 0),
                  child: Texture(textureId: textureId),
                ),
                SizedBox(),
              ],
            ),
          )
        : Container(height: 100, width: 100, child: SizedBox());
  }
}
