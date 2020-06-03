import 'dart:async';

import 'package:flutter/services.dart';

class ExternalTexturePlugin {
  static const MethodChannel _channel =
      const MethodChannel('external_textrure_plugin');

//
//  static Future<Map> loadTextureId() async {
//    return await _channel.invokeMethod("loadTextureId");
//  }

  static Future<Map> loadTextureImg(int textureId, {String url}) async {
    final args = <String, dynamic>{"textureId": textureId, "url": url};
    return await _channel.invokeMethod("loadTextureUrl", args);
  }

  static Future<Map> loadImg(String url) async {
    final args = <String, dynamic>{"url": url};
    return await _channel.invokeMethod("loadUrl", args);
  }

  static Future<Map> loadImgTest(String url) async {
    final args = <String, dynamic>{"url": url};
    return await _channel.invokeMethod("loadUrlTest", args);
  }

  static Future<String> release(String url) async {
    final args = <String, dynamic>{"url": url};
    return await _channel.invokeMethod("release", args);
  }
}
