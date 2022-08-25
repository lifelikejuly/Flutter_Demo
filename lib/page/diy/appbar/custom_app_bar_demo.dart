import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/magic/diy_refresh.dart';
import 'package:flutter_demo/magic/sliver/magic_app_bar.dart';
import 'package:flutter_demo/magic/sliver/magic_flexible_space_bar.dart';
import 'package:flutter_demo/magic/tab/magic_tab_indicator.dart';
import 'package:flutter_demo/magic/tab/magic_tabs.dart';
import 'package:flutter_demo/page/common/common.dart';
import 'package:flutter_demo/page/diy/tabbar/diy_tabbar_demo.dart';
import 'package:flutter_demo/page/widget/common_widget_demo.dart';
import 'package:flutter_demo/page/widget/scrollview/NestedClampingScrollPhysics.dart';

class CustomAppBarDemo extends StatefulWidget {
  @override
  State<CustomAppBarDemo> createState() => _AppBarDemoState();
}

class _AppBarDemoState extends State<CustomAppBarDemo>
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
  ];


  List<String> picUrls = [
    'images/bg0.jpeg',
    'images/bg1.jpeg',
    'images/bg2.jpeg',
    'images/bg3.jpeg',
    'images/bg0.jpeg',
    'images/bg1.jpeg',
    'images/bg2.jpeg',
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
    int index = 0;
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
      // tabPageViews.add(ListView.builder(itemBuilder: (context, index) {
      //   return Common.getWidget(index);
      // }));
      tabPageViews.add(CustomScrollView(
        physics: NestedClampingScrollPhysics(),
        slivers: <Widget>[
          CupertinoSliverRefreshControl(
            onRefresh: () async {

            },
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverFixedExtentList(
              itemExtent: 48.0,
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Common.getWidget(index);
                },
                childCount: 100,
              ),
            ),
          ),
        ],
      ));
      index++;
    });
    tabController1 = TabController(
      initialIndex: 0,
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = NestedScrollView(
       physics: NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            MagicSliverAppBar(
              leading: SizedBox(),
              floating: true,
              pinned: true,
              elevation: 0,
              expandedHeight: 92,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              forceElevated: innerBoxIsScrolled,
              flexibleSpace: MagicFlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: PreferredSize(
                  child: AppBar(
                    toolbarOpacity: 1.0,
                    bottomOpacity: 1.0,
                    backgroundColor: Colors.transparent,
                    shadowColor:Colors.transparent,
                    titleSpacing: 0.0,
                    automaticallyImplyLeading: false,
                    title: Container(
                      color:Colors.transparent,
                      padding: EdgeInsets.only(bottom: 11, left: 12, right: 12),
                      child: Container(
                        padding: EdgeInsets.only(left: 9),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Row(
                          children: [
                            Text("头像"),
                            Text("搜索栏"),
                            Text("入口"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  preferredSize: Size.fromHeight(48),
                ),
              ),
              bottom: PreferredSize(
                child: MagicTabBar(
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
                  indicatorPadding: EdgeInsets.zero,
                  indicatorWeight: 0,
                  indicator: MagicTabIndicator(
                      labelColors: colors,
                      pageController: tabController1,
                      borderSide:
                      BorderSide(width: 5.0, color: Colors.deepOrange),
                      // insets: EdgeInsets.all(10),
                      width: 20),
                ),
                preferredSize: Size.fromHeight(50),
              ),
            ),
          ];
        },
        body: MagicTabBarView(
            // 测试page切换临近Tab不做初始化
            controller: tabController1,
            children: tabPageViews,
        ));
    child = Stack(
      children: [
        AnimatedBuilder(animation: tabController1.animation, builder: (context, child) {
          double page = 0;
          int realPage = 0;
          page =  tabController1.index + tabController1.offset ?? 0;
          realPage = tabController1.index +  tabController1.offset?.floor() ?? 0;
          // if (realPage >= colors?.length) {
          //   page = 0;
          //   realPage = 0;
          // }
          double opacity = 1 - (page - realPage).abs();

          print("<> page $page realPage $realPage  ${tabController1?.offset}");

          int nextIndex = realPage + 1 < colors.length ? realPage + 1 : realPage;
          Color thisColor = colors != null ? colors[realPage] : Colors.white;
          Color nextColor = colors != null ? colors[nextIndex] : Colors.white;


          String thisPic = picUrls[realPage];
          String nextPic =
          picUrls[realPage + 1 < picUrls.length ? realPage + 1 : realPage];
          List<Widget> childs = List();
          if (thisPic != null && thisPic != '') {
            childs.add(Opacity(
              opacity: opacity,
              child: Image.asset(
                thisPic,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
                ),
              ),
            );
          }
          if (nextPic != null && nextPic != '') {
            childs.add(Opacity(
              opacity: 1 - opacity,
              child: Image.asset(
                picUrls[realPage + 1 < picUrls.length ? realPage + 1 : realPage],
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ));
          }
          return Stack(
            children: childs,
          );

        }),
        child,
      ],
    );

    return child;
  }
}
