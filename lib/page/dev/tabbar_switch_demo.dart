import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/diy_tabs.dart';
import 'package:flutter_demo/page/common/common.dart';

class TabBarSwitchDemo extends StatefulWidget {
  @override
  _TabBarSwitchDemoState createState() => _TabBarSwitchDemoState();
}

class _TabBarSwitchDemoState extends State<TabBarSwitchDemo>
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

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.blue,
    Colors.amber,
    Colors.cyan,
    Colors.pink
  ];
  Random random = new Random();

  Color getRandomColor() {
    return colors.elementAt(random.nextInt(colors.length));
  }

  List<Widget> tabWidgets;
  List<Widget> tabPageViews;
  TabController tabController1;
  TabController tabController2;

  @override
  void initState() {
    super.initState();
    tabWidgets = List();
    tabPageViews = List();
    tabs.forEach((element) {
      tabWidgets.add(Stack(
        children: <Widget>[
          Container(
            height: 50,
            padding: EdgeInsets.only(right: 12, left: 12),
            child: Text(
              element,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ));
      Color color = getRandomColor();
      tabPageViews.add(
          TabViewPage(color,element)
      );
    });
    tabController1 = TabController(
      initialIndex: 0,
      length: tabs.length,
      vsync: this,
    );
    tabController2 = TabController(
      initialIndex: 0,
      length: tabs.length,
      vsync: this,
    );
  }

  Widget _pageView(TabController tabController) {
    return Expanded(
      child: DIYTabBarView( // 测试page切换临近Tab不做初始化
        controller: tabController,
        children: tabPageViews,
      ),
    );
  }

  Widget _officialTabBarWidget() {
    return Container(
      height: 200,
      child: Column(
        children: <Widget>[
          TabBar(
            tabs: tabWidgets,
            controller: tabController1,
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
          _pageView(tabController1),
        ],
      ),
    );
  }
  // 自定义
  Widget _customerTabBarWidget() {
    return Container(
      height: 200,
      child: Column(
        children: <Widget>[
          DIYTabBar(
            tabs: tabWidgets,
            controller: tabController2,
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
            indicatorSize: DIYTabBarIndicatorSize.tab,
          ),
          _pageView(tabController2),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _officialTabBarWidget(),
        _customerTabBarWidget(),
      ],
    );
  }
}

class TabViewPage extends StatefulWidget {

  final Color color;
  final String element;


  TabViewPage(this.color, this.element);

  @override
  _TabViewPageState createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage> {


  @override
  void initState() {
    super.initState();
    print("<> _TabViewPageState initState ${widget.element}");
  }

  @override
  void dispose() {
    super.dispose();
    print("<> _TabViewPageState dispose ${widget.element}");
  }

  @override
  Widget build(BuildContext context) {
    print("<> _TabViewPageState build ${widget.element}");
    return Stack(
      children: <Widget>[
        Common.getWidget(widget.element.hashCode),
        Container(
          color: widget.color,
          child: Center(
            child: Text(
              widget.element,
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

