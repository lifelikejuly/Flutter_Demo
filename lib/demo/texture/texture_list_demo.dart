import 'package:flutter/material.dart';
import 'package:flutter_app_plugin/flutter_app_plugin.dart';
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

  @override
  void initState() {
    super.initState();
    _loadTextureId();
  }

  _loadTextureId() async {
//    if (textureId == null) {
//      var response = await FlutterAppPlugin.loadTextureId();
//      textureId = response["textureId"];
//    }
    var response = await FlutterAppPlugin.loadTextureImg(textureId ?? -1,
        url: imgs[widget.num % imgs.length]);
    textureId = response["textureId"];
    print(
        "_TextureTempState -- num: ${widget.num} -- textureId:${textureId.toString()}");

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    print("_TextureTempState -- dispose num: ${widget.num}");
  }

  @override
  Widget build(BuildContext context) {
    return textureId != null
        ? Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  child: Texture(textureId: textureId),
                ),
                SizedBox(),
              ],
            ),
          )
        : Container(height: 100, width: 100, child: SizedBox());
  }
}
