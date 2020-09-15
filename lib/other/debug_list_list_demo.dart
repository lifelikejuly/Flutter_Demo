import 'package:flutter/material.dart';

class DebugListListDemo extends StatefulWidget {
  @override
  _DebugListListDemoState createState() => _DebugListListDemoState();
}

class _DebugListListDemoState extends State<DebugListListDemo> {
  List<Widget> list = [];

  List<Widget> list2 = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 20; i++) {
      list2.add(Text("------$i--------------}"));
    }
    for (var i = 0; i < 200; i++) {
      list.add(Text("------$i--------------}"));
      if (i == 20) {
        list.add(
          Container(
            color: Colors.brown,
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: list2,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("列表嵌套列表Demo"),
      ),
      body: ListView(
        children: list,
      ),
    );
  }
}
