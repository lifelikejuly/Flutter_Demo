import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_demo/page/ui/bottom_nav_demo.dart';

class UIDemo extends StatefulWidget {
  @override
  _UIDemoState createState() => _UIDemoState();
}

class _UIDemoState extends State<UIDemo> {
  HashMap<String, Widget> demos = new HashMap();

  @override
  void initState() {
    super.initState();
    demos["ui_bottom_nav"] = BottomNavDemo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView(
          children: demos.entries.map((item) {
            return RaisedButton(
              child: Text(item.key),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => item.value,
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
