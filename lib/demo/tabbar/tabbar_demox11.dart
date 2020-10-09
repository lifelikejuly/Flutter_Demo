import 'package:flutter/material.dart';

import 'no_gradient_tabbarxx.dart';
import 'under_line_indicatorxx.dart';

class TabBarDemoX11 extends StatefulWidget {
  @override
  _TabBarDemo1State createState() => _TabBarDemo1State();
}

class _TabBarDemo1State extends State<TabBarDemoX11>
    with SingleTickerProviderStateMixin {
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
    for (int i = 0; i < tabs.length; i++) {
      tabWidgets.add(
        Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 1),
              ),
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 7.5, left: 12, right: 12),
              child: Text(
                tabs[i],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

//            Align(
//              alignment: Alignment.bottomCenter,
//              child: Text(
//                tabs[i],
//                maxLines: 1,
//                overflow: TextOverflow.ellipsis,
//              ),
//            )
          ],
        ),
      );

//      tabWidgets.add(
//        Container(
//          color: Colors.orange,
//          alignment: Alignment.bottomCenter,
//          height: 100,
//          padding: EdgeInsets.only(bottom: 7.5, left: 12, right: 12),
//          child: Text(
//            tabs[i],
//            maxLines: 1,
//            overflow: TextOverflow.ellipsis,
//          ),
//        ),
//      );
    }
    tabs.forEach((element) {
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
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            height: 42,
            width: MediaQuery.of(context).size.width,
            child: NoGradientTabBarXX(
              indicator: UnderLineIndicatorXX(
                borderSide: BorderSide(color: Color(0xFFFF1F50), width: 3),
                insets: EdgeInsets.only(bottom: 2),
                width: 25,
              ),
              controller: tabController,
              isScrollable: true,
              labelColor: Color(0xFF333333),
              unselectedLabelColor: Color(0xFF333333),
//              labelColor: Colors.white,
//              unselectedLabelColor: Colors.white,
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
            child: TabBarView(
              controller: tabController,
              children: tabPageViews,
            ),
          )
        ],
      ),
    );
  }
}
