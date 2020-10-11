import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_demo/page/common/common.dart';

class NestedScrollTabBarListDemo extends StatefulWidget {
  @override
  _NestedScrollTabBarListDemoState createState() =>
      _NestedScrollTabBarListDemoState();
}

class _NestedScrollTabBarListDemoState
    extends State<NestedScrollTabBarListDemo> {
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

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      innerController?.addListener(() {
        print(
            "NestedScrollTabBarListDemo innerController ${innerController.offset} - ${outerController.offset}");
      });
      outerController?.addListener(() {
        print(
            "NestedScrollTabBarListDemo outerController ${outerController.offset} - ${innerController.offset}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: NestedScrollView(
        key: globalKey,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
//            SliverOverlapAbsorber(
//              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//              sliver: SliverAppBar(
//                leading: Container(),
//                title: const Text('Books'),
//                pinned: true,
//                floating: true,
//                snap: false,
//                primary: true,
//                expandedHeight: 150.0,
//                forceElevated: innerBoxIsScrolled,
//                bottom: TabBar(
//                  isScrollable: true,
//                  tabs: _tabs.map((String name) => Tab(text: name)).toList(),
//                ),
//              ),
//            ),
            SliverAppBar(
              leading: Container(),
              title: const Text('Books'),
              pinned: true,
              floating: true,
              expandedHeight: 150.0,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                isScrollable: true,
                tabs: _tabs.map((String name) => Tab(text: name)).toList(),
              ),
            )
          ];
        },
        body: TabBarView(
          children: _tabs.map((String name) {
            return SafeArea(
              child: Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
//                      primary: true,
                    physics: BouncingScrollPhysics(),
                    key: PageStorageKey<String>(name),
                    slivers: <Widget>[
//                      SliverOverlapInjector(
//                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
//                            context),
//                      ),
                      CupertinoSliverRefreshControl(
                        onRefresh: () async {},
                      ),
                      SliverFixedExtentList(
                        itemExtent: 100,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Common.getWidget(index);
                          },
                          childCount: 100,
                        ),
                      )
                    ],
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
