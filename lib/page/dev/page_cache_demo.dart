import 'package:flutter/material.dart';

class PageCacheDemo extends StatefulWidget {
  @override
  _PageCacheDemoState createState() => _PageCacheDemoState();
}

class _PageCacheDemoState extends State<PageCacheDemo>
    with SingleTickerProviderStateMixin {
  List<String> _tabs = [
    "关注",
    "发现",
    "明星饭圈",
    "寻味指南",
    "史莱姆",
    "妈咪宝贝",
    "汉服同袍",
  ];

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          controller: tabController,
          labelColor: Colors.blue,
          isScrollable: true,
          tabs: _tabs
              .map((String name) => Container(
                    height: 30,
                    child: Text(
                      name,
                    ),
                  ))
              .toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: _tabs.map((e) => TabBarPage(e)).toList(),
          ),
        )
      ],
    );
  }
}

class TabBarPage extends StatefulWidget {
  final String name;

  TabBarPage(this.name);

  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {

  @override
  void initState() {
    super.initState();
    print("<page> initState ${widget.name}");
  }

  @override
  void dispose() {
    super.dispose();
    print("<page> dispose ${widget.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          widget.name,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
