//import 'package:flutter/material.dart';
//import 'package:external_texture_plugin/external_texture_plugin.dart';
//
//import 'mock.dart';
//
//class TextureSingleImageDemo extends StatefulWidget {
//  @override
//  _TextureDemoState createState() => _TextureDemoState();
//}
//
//class _TextureDemoState extends State<TextureSingleImageDemo> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(),
//      body: Column(
//        children: <Widget>[
//          TextureTemp(),
//        ],
//      ),
//    );
//  }
//}
//
//class TextureTemp extends StatefulWidget {
//  @override
//  _TextureTempState createState() => _TextureTempState();
//}
//
//class _TextureTempState extends State<TextureTemp> {
//  int textureId;
//  int width;
//  int height;
//
//  @override
//  void initState() {
//    super.initState();
//    _loadTextureId();
//  }
//
//  _loadTextureId() async {
//    var response = await ExternalTexturePlugin.loadTextureImg(textureId ?? 0,
//        url: imgs[0]);
//    if (response != null && response["textureId"] != null) {
//      textureId = response["textureId"];
//      width = response["width"];
//      height = response["height"];
//      print("_loadTextureId width $width height $height");
//      if (mounted) setState(() {});
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return textureId != null
//        ? Column(
//            children: <Widget>[
//              AspectRatio(
//                aspectRatio:
//                    (width?.toDouble() ?? 0) / (height?.toDouble() ?? 0),
//                child: Texture(textureId: textureId),
//              ),
//            ],
//          )
//        : SizedBox();
//  }
//}
