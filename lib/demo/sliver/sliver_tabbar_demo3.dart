import 'dart:math' as math;

import 'package:flutter/material.dart';

class SliverTabBarDemo3 extends StatefulWidget {
  @override
  _SliverTabBarDemoState createState() => _SliverTabBarDemoState();
}

class _SliverTabBarDemoState extends State<SliverTabBarDemo3>
    with SingleTickerProviderStateMixin {
//  TabController _tabController; // To control switching tabs
  ScrollController _scrollViewController; // To control scrolling
  ScrollController _scrollController2;

//
//  List<String> items = [];
//  List<Color> colors = [
//    Colors.red,
//    Colors.green,
//    Colors.yellow,
//    Colors.purple,
//    Colors.blue,
//    Colors.amber,
//    Colors.cyan,
//    Colors.pink
//  ];
//  Random random = new Random();
//
//  Color getRandomColor() {
//    return colors.elementAt(random.nextInt(colors.length));
//  }
  double beforeOffset = 0;

  @override
  void initState() {
    super.initState();
//    _tabController = TabController(vsync: this, length: 2);
    _scrollViewController = ScrollController();
    _scrollController2 = ScrollController();
//    WidgetsBinding.instance.addPostFrameCallback((_) {
//      this._scrollController2.addListener(() {
//        print("_scrollController2 ${_scrollController2.offset}");
//        double offset = this._scrollController2.offset;
//        if (offset <= 200) {
//          _scrollViewController.jumpTo(offset);
//        } else if (offset > 200) {
//          _scrollViewController.jumpTo(0);
//        }
//        // ScrollDirection direction = this.listViewController.position.userScrollDirection;
//      });
//    });
  }

  @override
  void dispose() {
    super.dispose();
//    _tabController.dispose();
//    _scrollViewController.dispose();
  }

  //例子2
  @override
  build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollViewController,
          physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool isScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                expandedHeight: 200,
                title: Text("Tab Bouncing Problem"),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text("Tab Bouncing Problem2222"),
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(text: "One"),
                    Tab(text: "Two"),
                    Tab(text: "Three"),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              MyTabContainer(_scrollController2, _scrollViewController),
              MyTabContainer(_scrollController2, _scrollViewController),
              MyTabContainer(_scrollController2, _scrollViewController),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTabContainer extends StatelessWidget {
  final ScrollController scrollController2;
  final ScrollController scrollController1;

  MyTabContainer(this.scrollController2, this.scrollController1);

  double offset = 0;
  double offset1 = 0;
  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
//      double progress = notification.metrics.pixels /
//          notification.metrics.maxScrollExtent;
//        if (notification.metrics.axisDirection == AxisDirection.up &&
//            notification.metrics.maxScrollExtent > 10) {
//          scrollController1.jumpTo(200);
//          print("NotificationListener ${notification.metrics.maxScrollExtent}");
//        }
//        print(
//            "NotificationListener  extentBefore ${notification.metrics.extentBefore} \n");
//        print(
//            "NotificationListener  extentAfter ${notification.metrics.extentAfter} \n");
        print(
            "NotificationListener  axisDirection ${notification.metrics.axisDirection} ");
//        print("NotificationListener  axis ${notification.metrics.axis} \n");
//        print(
//            "NotificationListener maxScrollExtent ${notification.metrics.maxScrollExtent} \n");
//        print(
//            "NotificationListener  minScrollExtent ${notification.metrics.minScrollExtent} \n");
//        print("NotificationListener  pixels ${notification.metrics.pixels} \n");
        double nowOffset = notification.metrics.pixels;
//        if (notification.metrics.axisDirection == AxisDirection.up) {
//          scrollController1.jumpTo(math.max(200, nowOffset));
//          print("NotificationListener  up $nowOffset \n");
//          offset += (offset - nowOffset);
//        } else if (notification.metrics.axisDirection == AxisDirection.down) {
//          scrollController1.jumpTo(nowOffset);
//          print("NotificationListener  down ${nowOffset} \n");
//          offset = nowOffset;
//        }
//        print("NotificationListener   $nowOffset \n");

        //pixels：当前滚动位置。
        //maxScrollExtent：最大可滚动长度。
        //extentBefore：滑出ViewPort顶部的长度；此示例中相当于顶部滑出屏幕上方的列表长度。
        //extentInside：ViewPort内部长度；此示例中屏幕显示的列表部分的长度。
        //extentAfter：列表中未滑入ViewPort部分的长度；此示例中列表底部未显示到屏幕范围部分的长度。
        //atEdge：是否滑到了可滚动组件的边界（此示例中相当于列表顶或底部）。
        //https://book.flutterchina.club/chapter6/scroll_controller.html

        if(nowOffset >= offset){ ///down
          offset1 += (nowOffset - offset);
          offset1 = math.min(200, offset1);
          scrollController1.jumpTo(offset1);
          print("NotificationListener down  $offset1 \n");
        }else{
          offset1 -= (offset - nowOffset);
          offset1 = math.max(offset1, 0);
          scrollController1.jumpTo(offset1);
          print("NotificationListener up  $offset1 \n");
        }
        offset = nowOffset;

        return false;
      },
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        controller: scrollController2, // *** THIS IS THE FIX ***
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text("Item: $index"),
          );
        },
      ),
    );
  }
}
