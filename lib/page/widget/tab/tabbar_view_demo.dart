import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';

class TabBarViewDemo extends StatefulWidget {
  @override
  _TabBarViewDemoState createState() => _TabBarViewDemoState();
}

class _TabBarViewDemoState extends State<TabBarViewDemo> {
  List<String> tabs = [
    "关注",
    "发现",
    "明星饭圈",
    "寻味指南",
    "史莱姆",
    "妈咪宝贝",
    "汉服同袍",
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: <Widget>[
          TabBar(
            tabs: tabs
                .map((element) => Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                element,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ))
                .toList(),
            isScrollable: true,
            labelColor: Color(0xFF333333),
            unselectedLabelColor: Color(0xFF333333),
            labelPadding: EdgeInsets.all(0),
            unselectedLabelStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
            ),
            labelStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(
            child: TabBarView(
              children: tabs.map((e) => TabBarViewPage(e)).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class TabBarViewPage extends StatefulWidget {
  final String name;

  TabBarViewPage(this.name);

  @override
  _TabBarViewPageState createState() => _TabBarViewPageState();
}

class _TabBarViewPageState extends State<TabBarViewPage> {

  @override
  void initState() {
    super.initState();
    print("<> _TabBarViewPageState initState ${widget.name}");
  }

  @override
  void dispose() {
    super.dispose();
    print("<> _TabBarViewPageState dispose ${widget.name}");
  }

  @override
  Widget build(BuildContext context) {
    print("<> _TabBarViewPageState build ${widget.name}");
    return Stack(
      children: <Widget>[
        Common.getWidget(widget.name.hashCode),
        Container(
          child: Center(
            child: Text(
              widget.name,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
