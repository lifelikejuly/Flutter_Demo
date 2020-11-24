import 'dart:math';

import 'package:flutter/material.dart';

class TabBarAddJumpDemo extends StatefulWidget {
  @override
  _TabBarAddJumpDemoState createState() => _TabBarAddJumpDemoState();
}

class _TabBarAddJumpDemoState extends State<TabBarAddJumpDemo>
    with TickerProviderStateMixin {
  List<String> tabs = [
    "Page1",
    "Page2",
    "Page3",
    "Page4",
    "Page5",
    "Page6",
    "Page7",
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

  List<Widget> tabWidgets;
  List<Widget> tabPageViews;
  TabController tabController;

  Color getRandomColor() {
    return colors.elementAt(random.nextInt(colors.length));
  }

  @override
  void initState() {
    super.initState();
    _initDates();
    tabController = TabController(
      initialIndex: 0,
      length: tabs.length,
      vsync: this,
    );
  }

  _initDates(){
    tabWidgets = List();
    tabPageViews = List();
    tabs.forEach((element) {
      tabWidgets.add(
        Container(
          height: 50,
          padding: EdgeInsets.only(right: 12, left: 12),
          child: Text(
            element,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
      Color color = getRandomColor();
      tabPageViews.add(
        Container(
          color: color,
          child: Center(
            child: Text(
              element,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 500,
          child: Column(
            children: <Widget>[
              TabBar(
                tabs: tabWidgets,
                controller: tabController,
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
                  controller: tabController,
                  children: tabPageViews,
                ),
              )
            ],
          ),
        ),
        Row(
          children: <Widget>[
            FlatButton(
              child: Text("+ Page"),
              onPressed: (){
                tabs.add("测试${tabs.length}");
                _initDates();
                tabController = TabController(
                  initialIndex: tabs.length - 1,
                  length: tabs.length,
                  vsync: this,
                );
                setState(() {

                });
              },
            ),
            FlatButton(
              child: Text("- Page"),
              onPressed: () {
                tabs.removeAt(tabs.length - 1);
                _initDates();
                tabController = TabController(
                  initialIndex: tabs.length - 1,
                  length: tabs.length,
                  vsync: this,
                );
                setState(() {});
              },
            ),
            FlatButton(
              child: Text("New + Page"),
              onPressed: (){
                tabs.add("测试${tabs.length}");
                _initDates();
                tabController = TabController(
                  initialIndex: 0,
                  length: tabs.length,
                  vsync: this,
                );
                setState(() {

                });
                Future.delayed(Duration(seconds: 1),(){
                  tabController.animateTo(tabs.length - 1);
                });
              },
            ),
          ],
        )
      ],
    );
  }
}
