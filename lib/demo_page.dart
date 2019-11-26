import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_demo/demo/animation/animation_demo.dart';
import 'package:flutter_demo/demo/dart/async_demo.dart';
import 'package:flutter_demo/demo/drawer/drag_drawer_demo.dart';
import 'package:flutter_demo/demo/flip/flip_demo.dart';
import 'package:flutter_demo/part/refresh_demo.dart';
import 'package:flutter_demo/part/swiper_demo.dart';
import 'package:flutter_demo/ui/bottom_nav_demo.dart';
import 'package:flutter_demo/ui/dialog_demo.dart';


class DemoPage extends StatefulWidget {
  String type;

  DemoPage(this.type);

  @override
  _UIDemoState createState() => _UIDemoState();
}

class _UIDemoState extends State<DemoPage> {
  HashMap<String, Widget> demos = new HashMap();

  @override
  void initState() {
    super.initState();
    switch (widget.type) {
      case "ui":
        demos["底部导航"] = BottomNavDemo();
        demos["弹窗"] = DialogDemo();
        break;
      case "part":
        demos["轮播组件"] = SwiperDemo();
        demos["列表刷新组件"] = RefreshDemo();
        break;
      case "other":
        demos["drawer"] = DrawerDemo();
        demos["flip"] = FlipDemo();
        demos["animation"] = AnimationDemo();
        break;
      case "dart":
        demos["async"] = AsyncDemo();
        break;
    }
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
