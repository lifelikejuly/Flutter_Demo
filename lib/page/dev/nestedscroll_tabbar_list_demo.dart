import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/mock/img_mock.dart';
import 'package:flutter_demo/page/common/common.dart';
import 'package:flutter_demo/page/lib/waterfall/src/rendering/sliver_waterfall_flow.dart';
import 'package:flutter_demo/page/lib/waterfall/src/widgets/sliver.dart';
import 'dart:math' as math;

class NestedScrollTabBarListDemo extends StatefulWidget {
  @override
  _NestedScrollTabBarListDemoState createState() =>
      _NestedScrollTabBarListDemoState();
}

class _NestedScrollTabBarListDemoState extends State<NestedScrollTabBarListDemo>
    with TickerProviderStateMixin {
  List<String> _tabs = [
    "关注",
    "发现",
    "明星饭圈",
    "寻味指南",
    "史莱姆",
    "妈咪宝贝",
    "汉服同袍",
  ];

  final GlobalKey<NestedScrollViewState> globalKey = GlobalKey();

  ScrollController get innerController {
    return globalKey?.currentState?.innerController;
  }

  ScrollController get outerController {
    return globalKey?.currentState?.outerController;
  }

  TabController tabController;

  ScrollController childScrollController;
  ScrollController fatherScrollController;
  double offset = 0;

  @override
  void initState() {
    super.initState();
//    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//      innerController?.addListener(() {
//        print(
//            "NestedScrollTabBarListDemo innerController ${innerController.offset} - ${outerController.offset}");
//      });
//      outerController?.addListener(() {
//        print(
//            "NestedScrollTabBarListDemo outerController ${outerController.offset} - ${innerController.offset}");
//
//          setState(() {
//
//          });
//      });
//    });
    tabController = TabController(length: _tabs.length, vsync: this);
    tabController.addListener(() {
      print("NestedScrollTabBarListDemo offset ${tabController.offset}");
      setState(() {});
    });
    childScrollController = ScrollController();
    fatherScrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return _sample1();
  }

  Widget _sample1() {
    Widget child = NestedScrollView(
      key: globalKey,
      controller: fatherScrollController,
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
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: PreferredSize(
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.redAccent,
                  titleSpacing: 0.0,
                  automaticallyImplyLeading: false,
                  //backgroundColor: Colors.red,
                  title: Container(
                    padding: EdgeInsets.only(bottom: 11, left: 12, right: 12),
                    child: Text("Title"),
                  ),
                ),
                preferredSize: Size.fromHeight(44),
              ),
            ),
            bottom: TabBar(
              controller: tabController,
              indicatorColor: Colors.orange,
              isScrollable: true,
              unselectedLabelColor: Colors.orange.withOpacity(0.5),
              labelPadding: EdgeInsets.all(0),
              unselectedLabelStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.orange,
              ),
              labelStyle: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Colors.orange,
              ),
              labelColor: Colors.orange,
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
      body: TabBarView(
        controller: tabController,
        children: _tabs.map((String name) {
          Widget child = CustomScrollView(
            controller: childScrollController,
            physics: BouncingScrollPhysics(),
            key: PageStorageKey<String>(name),
            slivers: <Widget>[
              CupertinoSliverRefreshControl(
                onRefresh: () async {},
              ),
              SliverToBoxAdapter(
                child: Common.getWidget(0),
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
          child = NotificationListener(
            child: child,
            onNotification: (position) {
              offset = _listenerScrollOffset(
                  position, offset, fatherScrollController);
              return false;
            },
          );
          return child;
        }).toList(),
      ),
    );

    return child;
  }

  _listenerScrollOffset(ScrollNotification position, double offset,
      ScrollController fatherController) {
    // 监听滑动 当滑动为水平方向
    if (position is ScrollUpdateNotification &&
        position.depth == 0 &&
        position.metrics.axis == Axis.vertical) {
      double nowOffset = position.metrics.pixels;
      double fatherOffset = fatherController.offset;
      if (!position.metrics.atEdge && nowOffset > 50) {
        if (nowOffset >= offset) {// 下滑操作
          if (fatherOffset < 44) {
            fatherOffset += (nowOffset - offset);
            fatherOffset = math.min(44, fatherOffset);
            fatherController?.jumpTo(fatherOffset);
          }
        } else {
          if (fatherOffset > 0) { // 上滑操作
            fatherOffset -= (offset - nowOffset);
            fatherOffset = math.max(fatherOffset, 0);
            fatherController?.jumpTo(fatherOffset);
          }
        }
      } else { //切换Tab后的情况 主要是切换Tab后做下拉刷新的操作
        if (fatherOffset > 0 && nowOffset < offset) {
          fatherController?.jumpTo(0);
        }
      }
      return nowOffset;
    }
    return offset;
  }

}
