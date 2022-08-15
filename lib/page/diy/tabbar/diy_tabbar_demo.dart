

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/tab/magic_tab_indicator.dart';
import 'package:flutter_demo/magic/tab/magic_tabs.dart';
import 'package:flutter_demo/page/common/common.dart';

class DiyTabbarDemo extends StatefulWidget {

  @override
  State<DiyTabbarDemo> createState() => _DiyTabbarDemoState();
}

class _DiyTabbarDemoState extends State<DiyTabbarDemo> with TickerProviderStateMixin {


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
  ];


  List<Widget> tabWidgets;
  List<Widget> tabPageViews;
  TabController tabController1;

  Random random = new Random();

  Color getRandomColor() {
    return colors.elementAt(random.nextInt(colors.length));
  }

  @override
  void initState() {
    super.initState();
    int index =0;
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
      tabPageViews.add(
          TabViewPage(colors[index],element)
      );
      index ++;
    });
    tabController1 = TabController(
      initialIndex: 0,
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MagicTabBar(
          tabs: tabWidgets,
          controller: tabController1,
          isScrollable: true,
          labelColors: colors,
          labelColor: Color(0xFF333333),
          unselectedLabelColor: Colors.deepOrange,
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
          indicatorSize: MagicTabBarIndicatorSize.tab,
          indicatorColor: Colors.deepOrange,
          indicatorPadding: EdgeInsets.all(10),
          indicator: MagicTabIndicator(
            labelColors: colors,
            pageController: tabController1,
            borderSide: BorderSide(width: 5.0, color: Colors.deepOrange),
            // insets: EdgeInsets.all(10),
            width: 20
          ),
        ),
        Expanded(
          child: MagicTabBarView( // 测试page切换临近Tab不做初始化
            controller: tabController1,
            children: tabPageViews,
          ),
        )
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
  Widget build(BuildContext context) {
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
