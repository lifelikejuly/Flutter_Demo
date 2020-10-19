import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_demo/magic/diy_color_box.dart';
import 'package:flutter_demo/magic/diy_flexible_space_widget.dart';
import 'package:flutter_demo/magic/diy_tabs.dart';
import 'package:flutter_demo/mock/img_mock.dart';
import 'package:flutter_demo/page/common/common.dart';
import 'package:flutter_demo/page/lib/waterfall/src/rendering/sliver_waterfall_flow.dart';
import 'package:flutter_demo/page/lib/waterfall/src/widgets/sliver.dart';

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

  bool showPic = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      innerController?.addListener(() {
//        print(
//            "NestedScrollTabBarListDemo innerController ${innerController.offset} - ${outerController.offset}");
      });
      outerController?.addListener(() {
//        print(
//            "NestedScrollTabBarListDemo outerController ${outerController.offset} - ${innerController.offset}");

//          setState(() {
//
//          });
      });
    });
    tabController = TabController(length: _tabs.length, vsync: this);
    tabController.addListener(() {
      print("NestedScrollTabBarListDemo offset ${tabController.offset}");
      showPic = tabController.index == 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _sample2();
  }

  Widget _sample1BackGround() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      color: Colors.brown,
      child: Visibility(
        visible: showPic,
        child: Image.network(
          mockImgs[0],
          width: MediaQuery.of(context).size.width,
          height: 200,
          fit: BoxFit.fitWidth,
        ),
        replacement: SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
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
            bottom: DIYTabBar(
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
          return SafeArea(
            child: Builder(
              builder: (BuildContext context) {
                return CustomScrollView(
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
//                      SliverFixedExtentList(
//                        itemExtent: 100,
//                        delegate: SliverChildBuilderDelegate(
//                          (BuildContext context, int index) {
//                            return Common.getWidget(index);
//                          },
//                          childCount: 100,
//                        ),
//                      )
                  ],
                );
              },
            ),
          );
        }).toList(),
      ),
    );
//    child = Stack(
//      children: <Widget>[
//        // 渐变组件
//        _sample1BackGround(),
//        child,
//      ],
//    );

    child = DIYTopHeaderAdapter(
      child: child,
    );

    return child;
  }

  Widget _sample2() {
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: CustomScrollView(
//        key: globalKey,
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            leading: Container(),
            title: const Text('Books'),
            pinned: true,
            floating: true,
            expandedHeight: 150.0,
            bottom: TabBar(
              isScrollable: true,
              tabs: _tabs.map((String name) => Tab(text: name)).toList(),
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {},
          ),
//          SliverList(
//            delegate: SliverChildBuilderDelegate(
//              (BuildContext context, int index) {
//                return Common.getWidget(index);
//              },
//              childCount: 100,
//            ),
//          )
          SliverFillRemaining(
            child: TabBarView(
              children: _tabs
                  .map((e) => CustomScrollView(
                        slivers: <Widget>[
//                          CupertinoSliverRefreshControl(
//                            onRefresh: () async {},
//                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Common.getWidget(index);
                              },
                              childCount: 100,
                            ),
                          )
                        ],
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
