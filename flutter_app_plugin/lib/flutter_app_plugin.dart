import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAppPlugin {
  static const MethodChannel _channel =
  const MethodChannel('flutter_app_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> nativePage(String path) async {
    final args = <String, dynamic>{
      "router": path
    };
    final bool result = await _channel.invokeMethod('goToNativePage',args);
    return result;
  }
}
