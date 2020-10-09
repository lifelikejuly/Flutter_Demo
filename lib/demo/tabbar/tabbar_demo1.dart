import 'package:flutter/material.dart';

import 'dynamic_page.dart';
import 'no_tabbar.dart';
import 'underLineIndicator.dart';

class TabBarDemo1 extends StatefulWidget {
  @override
  _TabBarDemo1State createState() => _TabBarDemo1State();
}

class _TabBarDemo1State extends State<TabBarDemo1>
    with TickerProviderStateMixin {
  List<String> tabs = [
    "关注",
    "发现",
    "明星饭圈",
    "寻味指南",
    "史莱姆",
    "妈咪宝贝",
    "汉服同袍",
  ];

  List<Widget> tabWidgets;
  List<Widget> tabPageViews;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabWidgets = List();
    tabPageViews = List();
    tabs.forEach((element) {
      tabWidgets.add(Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepOrange, width: 1),
            ),
            padding: EdgeInsets.only(bottom: 7.5, right: 12),
            alignment: Alignment.bottomLeft,
            child: Text(
              element,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ));
      tabPageViews.add(Container(
        child: Center(
          child: Text(element),
        ),
      ));
    });
    tabController = TabController(
      initialIndex: 0,
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.add),
            onPressed: () {
              tabs.add("测试${tabs.length}");
              tabWidgets = List();
              tabPageViews = List();
              tabs.forEach((element) {
                tabWidgets.add(Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepOrange, width: 1),
                      ),
                      padding: EdgeInsets.only(bottom: 7.5, right: 12),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        element,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ));
                tabPageViews.add(Container(
                  child: Center(
                    child: Text(element),
                  ),
                ));
              });
              tabController = TabController(
                initialIndex: tabs.length - 1,
                length: tabs.length,
                vsync: this,
              );
              setState(() {});
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 42,
            width: MediaQuery.of(context).size.width,
            child: NoGradientTabBar(
              indicator: UnderLineIndicator(
                borderSide: BorderSide(color: Color(0xFFFF1F50), width: 3),
                insets: EdgeInsets.only(bottom: 2),
                width: 25,
              ),
              controller: tabController,
              isScrollable: true,
              labelColor: Color(0xFF333333),
              unselectedLabelColor: Color(0xFF333333),
              labelPadding: EdgeInsets.all(0),
              unselectedLabelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF333333),
              ),
              labelStyle: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: tabWidgets,
            ),
          ),
          Expanded(
            child: DynamicTabBarView(
              controller: tabController,
              children: tabPageViews,
            ),
          )
        ],
      ),
    );
  }
}
