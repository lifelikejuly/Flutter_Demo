import 'package:flutter/material.dart';
import 'package:flutter_demo/demo/sliver/sliver_tabbar_demo3.dart';

import 'sliver_tabbar_demo.dart';
import 'sliver_tabbar_demo2.dart';

class SliverDemo extends StatefulWidget {
  @override
  _SliverDemoState createState() => _SliverDemoState();
}

class _SliverDemoState extends State<SliverDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          FlatButton(
            child: Text("Demo1"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SliverTabBarDemo(),
                ),
              );
            },
          ),
          FlatButton(
            child: Text("Demo2"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SliverTabBarDemo2(),
                ),
              );
            },
          ),
          FlatButton(
            child: Text("Demo3"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SliverTabBarDemo3(),
                ),
              );
            },
          )
        ],
      ),
    );

  }
}
