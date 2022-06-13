import 'package:flutter/material.dart';

class NativeDemo extends StatefulWidget {
  @override
  _NativeDemoState createState() => _NativeDemoState();
}

class _NativeDemoState extends State<NativeDemo> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        RaisedButton(
          child: Text("NativePage"),
          onPressed: () async {
            // await FlutterAppPlugin.nativePage("web");
          },
        ),
        FlatButton(
          child: Text("success"),
          onPressed: () async {
            // Map map = await FlutterAppPlugin.testChanelSuccess();
            // Scaffold.of(context).showSnackBar(
            //     SnackBar(content: Text("testChannel ${map.toString()} ${map["yes"]}"))
            // );
          },
        ),
        FlatButton(
          child: Text("fail"),
          onPressed: () async {
            try{
              // Map map = await FlutterAppPlugin.testChanelFail();
              // print("testChannel ${map.toString()}");
              // Scaffold.of(context).showSnackBar(
              //     SnackBar(content: Text("testChannel ${map.toString()}"))
              // );
            }catch(e){
              print("testChannel error${e.toString()}");
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("testChannel error ${e.toString()} "))
              );
            }
          },
        )
      ],
    );
  }
}
