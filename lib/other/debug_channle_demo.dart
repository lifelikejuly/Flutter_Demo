import 'package:flutter/material.dart';
import 'package:flutter_app_plugin/flutter_app_plugin.dart';

class DebugChannelDemo extends StatefulWidget {
  @override
  _DebugChannelDemoState createState() => _DebugChannelDemoState();
}

class _DebugChannelDemoState extends State<DebugChannelDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          FlatButton(
            child: Text(" success"),
            onPressed: () async {
              Map map = await FlutterAppPlugin.testChanelSuccess();
              print("testChannel ${map.toString()}");
            },
          ),
          FlatButton(
            child: Text("faile"),
            onPressed: () async {
              try{
                Map map = await FlutterAppPlugin.testChanelFail();
                print("testChannel ${map.toString()}");
              }catch(e){
                print("testChannel error${e.toString()}");
              }
            },
          )
        ],
      ),
    );
  }
}
