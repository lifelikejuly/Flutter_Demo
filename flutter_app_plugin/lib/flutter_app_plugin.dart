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
    final args = <String, dynamic>{"router": path};
    final bool result = await _channel.invokeMethod('goToNativePage', args);
    return result;
  }

  static Future<bool> makeJavaCrash() async {
    final bool result = await _channel.invokeMethod('crash');
    return result;
  }

  static Future<Map> testChanelSuccess() async {
    final Map result = await _channel.invokeMethod('testChannel', {"ok": 0});
    return result;
  }

  static Future<Map> testChanelFail() async {
    final Map result = await _channel.invokeMethod('testChannel', {"ok": 1});
    return result;
  }

  static void setHandler(handler) {
    _channel.setMethodCallHandler(handler);
  }
}
