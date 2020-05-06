import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_plugin/flutter_app_plugin.dart';

class PluginChannelDemo extends StatefulWidget {
  @override
  _PluginChannelDemoState createState() => _PluginChannelDemoState();
}

class _PluginChannelDemoState extends State<PluginChannelDemo> {
  String version = "";
  String nativeMessage = "";

  @override
  void initState() {
    super.initState();
    FlutterAppPlugin.setHandler((MethodCall call) {
      setState(() {
        nativeMessage = call.arguments;
      });
      return Future.value("Hello too");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text(version),
          RaisedButton(
            child: Text("getVersion"),
            onPressed: () async {
              String getVersion = await FlutterAppPlugin.platformVersion;
              setState(() {
                version = getVersion;
              });
            },
          ),
          RaisedButton(
            child: Text("跳转到MessageActivity"),
            onPressed: () async {
              await FlutterAppPlugin.nativePage("messenger");
            },
          ),
          Text("原生传递的数据 $nativeMessage")
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    FlutterAppPlugin.setHandler(null);
  }
}
