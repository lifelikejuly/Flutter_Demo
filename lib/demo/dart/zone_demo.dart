import 'dart:async';

import 'package:flutter/material.dart';

class ZoneDemo extends StatefulWidget {
  @override
  _ZoneDemoState createState() => _ZoneDemoState();
}

class _ZoneDemoState extends State<ZoneDemo> {

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load(){
    Zone.root.run((){
      print("Zone.root.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[

        ],
      ),
    );
  }
}
