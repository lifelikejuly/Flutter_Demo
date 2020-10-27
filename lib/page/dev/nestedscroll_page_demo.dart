import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_demo/magic/diy_flexible_space_widget.dart';
import 'package:flutter_demo/magic/diy_refresh.dart';
import 'package:flutter_demo/magic/diy_tabs.dart';
import 'package:flutter_demo/magic/diy_transformer_background_widget.dart';
import 'package:flutter_demo/mock/img_mock.dart';
import 'package:flutter_demo/page/common/common.dart';
import 'package:flutter_demo/page/lib/transformer_demo.dart';
import 'package:flutter_demo/page/lib/waterfall/src/rendering/sliver_waterfall_flow.dart';
import 'package:flutter_demo/page/lib/waterfall/src/widgets/sliver.dart';

List<String> _tabs = [
  "关注",
  "发现",
  "明星饭圈",
  "寻味指南",
  "史莱姆",
  "妈咪宝贝",
  "汉服同袍",
];

final List<Color> backgroundColors = [
  Colors.redAccent,
  Colors.pink,
  Colors.white,
  Colors.lightBlue,
  Colors.blueGrey,
  Colors.greenAccent,
  Colors.pinkAccent,
];

class NestedScrollPageDemo extends StatefulWidget {
  @override
  _NestedScrollPageDemoState createState() => _NestedScrollPageDemoState();
}

class _NestedScrollPageDemoState extends State<NestedScrollPageDemo>
    with TickerProviderStateMixin {
  final GlobalKey<NestedScrollViewState> globalKey = GlobalKey();

  final GlobalKey<DIYCupertinoSliverRefreshControlState> globalKey2 = GlobalKey();

  ScrollController get innerController {
    return globalKey?.currentState?.innerController;
  }

  ScrollController get outerController {
    return globalKey?.currentState?.outerController;
  }

  TabController tabController;
  PageController pageController;
  PageController pageController2;
  bool showPic = true;

  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
//    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//      innerController?.addListener(() {
////        print(
////            "NestedScrollTabBarListDemo innerController ${innerController.offset} - ${outerController.offset}");
//      });
//      outerController?.addListener(() {
////        print(
////            "NestedScrollTabBarListDemo outerController ${outerController.offset} - ${innerController.offset}");
//
////          setState(() {
////
////          });
//      });
//    });
    tabController =
        TabController(initialIndex: 0, length: _tabs.length, vsync: this);
    tabController.addListener(() {
      print("NestedScrollTabBarListDemo offset ${tabController.offset}");
//      showPic = tabController.index == 0;
//      setState(() {});
    });
    pageController = PageController(initialPage: 0);
//    pageController.addListener(() {
//      pageController2.jumpTo(pageController.offset);
//    });
//    pageController2 = PageController(initialPage: 0);

  }

  @override
  Widget build(BuildContext context) {
    return _sample1();
  }

  Widget _sample1() {
    Widget child = NestedScrollView(
      key: globalKey,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Container(),
            pinned: true,
            floating: true,
            expandedHeight: 150.0,
            forceElevated: innerBoxIsScrolled,
            flexibleSpace: DIYFlexibleSpaceBar(
              pageController: pageController,
              collapseMode: CollapseMode.pin,
              background: PreferredSize(
                child: AppBar(
                  elevation: 0,
                  titleSpacing: 0.0,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  title: Container(
                    padding: EdgeInsets.only(bottom: 11, left: 12, right: 12),
                    child: Text("Title"),
                  ),
                ),
                preferredSize: Size.fromHeight(44),
              ),
            ),
            bottom: DIYTabBar(
              indicator: DIYUnderLineIndicator(
                pageController: pageController,
                borderSide: BorderSide(
                    color: Common.labelColors[tabController.index], width: 3),
                insets: EdgeInsets.only(left: 12, right: 12, bottom: 2),
                width: 25,
              ),
              controller: tabController,
              isScrollable: true,
              labelPadding: EdgeInsets.all(0),
              unselectedLabelStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.blueAccent,
              ),
              labelStyle: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Colors.orange,
              ),
              labelColor: Colors.greenAccent,
              unselectedLabelColor: Colors.yellowAccent,
              indicatorColor: Colors.pinkAccent,
              tabs: _tabs
                  .map((String name) => Container(
                        height: 30,
                        child: Text(
                          name,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ];
      },
      body: DIYBarView(
        controller: tabController,
        pageController: pageController,
        children: _tabs.map((String name) {
          return CustomScrollView(
            controller: scrollController,
            physics: BouncingScrollPhysics(),
//            key: PageStorageKey<String>(name),
            slivers: <Widget>[
              DIYCupertinoSliverRefreshControl(
                key: globalKey2,
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 2));
                },
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  height: 300,
                  width: 200,
                  color: Common.colors[_tabs.indexOf(name)].withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Text(
                    "$name",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverWaterfallFlow(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Widget child = CachedNetworkImage(
                      imageUrl: mockImgs[index],
                    );
                    child = GestureDetector(
                      child: child,
                      onTap: () async {
                        setState(() {});
                      },
                    );
                    return child;
                  },
                  childCount: mockImgs.length,
                ),
                gridDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 9,
                  crossAxisSpacing: 9,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
    child = DIYTopHeaderAdapter(
      child: child,
      header: _sample1BackGround(),
    );
    child = Container(
      child: Stack(
        children: <Widget>[
          AnimatedBuilder(
            animation: scrollController,
            builder: (context, widget) {
              double pageOffset = 0;
              if (scrollController?.hasClients ?? false) {
                pageOffset = scrollController.offset;
              }
              DIYCupertinoSliverRefreshControlState refresh = globalKey2?.currentState;
              pageOffset += ((refresh?.hasSliverLayoutExtent ?? false) ? -60 : 0);
              print("<AnimatedBuilder> pageOffset $pageOffset  hasSliverLayoutExtent ${refresh?.hasSliverLayoutExtent ?? false}");
              return Positioned(
                top: 150.0 - (pageOffset < 100 ? pageOffset : 100),
                child: widget,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.yellowAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          child,
        ],
      ),
    );
    return child;
  }

  Widget _sample1BackGround() {
    return DIYTransformerWidget(
      pageController: pageController,
      picHeight: 100,
      picUrls: mockImgs,
      colors: Common.colors,
      backgroundHeight: 200,
    );
  }
}
