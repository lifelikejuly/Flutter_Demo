import 'dart:async';

import 'package:flutter/services.dart';

class ExternalTexturePlugin {
  static const MethodChannel _channel =
      const MethodChannel('external_textrure_plugin');

  static Future<Map> loadImg(String url, {int id}) async {
    final args = <String, dynamic>{"url": url, "id": id};
    return await _channel.invokeMethod("loadUrl", args);
  }

  static Future<String> release(String url) async {
    final args = <String, dynamic>{"url": url};
    return await _channel.invokeMethod("release", args);
  }
}
