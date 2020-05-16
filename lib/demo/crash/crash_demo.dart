import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_plugin/flutter_app_plugin.dart';

class CrashDemo extends StatefulWidget {
  @override
  _CrashDemoState createState() => _CrashDemoState();
}

class _CrashDemoState extends State<CrashDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              child: new Text(' StateError'),
              elevation: 1.0,
              onPressed: () {
                throw new StateError('This is a Dart StateError.');
              },
            ),
            new RaisedButton(
              child: new Text(' StackOverflowError'),
              elevation: 1.0,
              onPressed: () {
                throw StackOverflowError();
              },
            ),
            new RaisedButton(
              child: new Text(' Exception'),
              elevation: 1.0,
              onPressed: () {
                throw new Exception('This is a Dart Exception.');
              },
            ),
            new RaisedButton(
              child: new Text('async Dart exception'),
              elevation: 1.0,
              onPressed: () async {
                foo() async {
                  throw new StateError('This is an async Dart exception.');
                }

                bar() async {
                  await foo();
                }

                await bar();
              },
            ),
            new RaisedButton(
              child: new Text('Java exception'),
              elevation: 1.0,
              onPressed: () async {
                await FlutterAppPlugin.makeJavaCrash();
              },
            ),
          ],
        ),
      ),
    );
  }
}
