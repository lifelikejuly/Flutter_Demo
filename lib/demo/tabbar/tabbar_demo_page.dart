import 'package:flutter/material.dart';
import 'package:flutter_demo/demo/tabbar/tabbar_demo111.dart';

import 'tabbar_demo1.dart';
import 'tabbar_demo11.dart';
import 'tabbar_demo2.dart';
import 'tabbar_demo3.dart';
import 'tabbar_demox11.dart';

class TabBarDemoPage extends StatefulWidget {
  @override
  _TabBarDemoPageState createState() => _TabBarDemoPageState();
}

class _TabBarDemoPageState extends State<TabBarDemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TabBar例子集合"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FlatButton(
              child: Text("TabBar-Demo1"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => TabBarDemo1(),
                  ),
                );
              },
            ),
            FlatButton(
              child: Text("TabBar-Demo11"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => TabBarDemo11(),
                  ),
                );
              },
            ),
            FlatButton(
              child: Text("TabBar-Demox11"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => TabBarDemoX11(),
                  ),
                );
              },
            ),
            FlatButton(
              child: Text("TabBar-Demo111"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => TabBarDemo111(),
                  ),
                );
              },
            ),
            FlatButton(
              child: Text("TabBar-Demo2"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => TabBarDemo2(),
                  ),
                );
              },
            ),
            FlatButton(
              child: Text("TabBar-Demo3"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => TabbarDemo3(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
