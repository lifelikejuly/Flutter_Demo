import 'package:flutter/material.dart';
import 'package:flutter_app_plugin/flutter_app_plugin.dart';

class NativeDemo extends StatefulWidget {
  @override
  _NativeDemoState createState() => _NativeDemoState();
}

class _NativeDemoState extends State<NativeDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          RaisedButton(
            child: Text("NativePage"),
            onPressed: () async {
              await FlutterAppPlugin.nativePage("web");
            },
          )
        ],
      ),
    );
  }
}
