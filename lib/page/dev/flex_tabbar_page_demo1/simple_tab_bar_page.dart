import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/magic/diy_sliver_header.dart';
import 'package:flutter_demo/mock/img_mock.dart';
import 'package:flutter_demo/page/common/common.dart';
import 'package:flutter_demo/page/lib/waterfall/src/rendering/sliver_waterfall_flow.dart';
import 'package:flutter_demo/page/lib/waterfall/src/widgets/sliver.dart';

import 'sub_tab_list_page.dart';

import "dart:math";

class SimpleTabBarView extends StatefulWidget {
  final int index;

  SimpleTabBarView(this.index);

  @override
  _SimpleTabBarViewState createState() => _SimpleTabBarViewState();
}

class _SimpleTabBarViewState extends State<SimpleTabBarView> {
  @override
  void initState() {
    super.initState();
    print("<> _SimpleTabBarViewState");
  }

  List<String> _tabs = [
    "kkjkjjk1",
    "kkjkjjk2",
    "kkjkjjk3",
    "kkjkjjk4",
    "kkjkjjk5",
  ];

  @override
  Widget build(BuildContext context) {
    Widget child = CustomScrollView(
      key: PageStorageKey("TabBarViewPage-${widget.index}"),
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        CupertinoSliverRefreshControl(
          onRefresh: () async {},
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _tabs
                  .map((e) => Container(
                width: 100,
                height: 50,
                color: Colors.pink,
                alignment: Alignment.center,
                child: Text(e),
              ))
                  .toList(),
            ),
          ),
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
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 9,
            crossAxisSpacing: 9,
          ),
        ),
      ],
    );
    return child;
  }
}

class FirstTabBarView extends StatefulWidget {
  final ScrollController scrollController;

  FirstTabBarView(this.scrollController);

  @override
  _FirstTabBarViewState createState() => _FirstTabBarViewState();
}

class _FirstTabBarViewState extends State<FirstTabBarView>
    with TickerProviderStateMixin {
  TabController tabController1;
  List<String> _tabs = [
    "subTab1",
    "subTab2",
    "subTab3",
    "subTab4",
    "subTab5",
  ];

  Stream<double> offsetStream;
  StreamController<double> _headerController;

  ScrollController _scrollController1;

  @override
  void initState() {
    super.initState();
    _scrollController1 = ScrollController();
    tabController1 = TabController(length: _tabs.length, vsync: this);

    _headerController = StreamController.broadcast();
    offsetStream = _headerController.stream;
    _scrollController1?.addListener(() {
      double offset = _scrollController1?.offset ?? 0;
      double height = 0;
      if (offset >= 310) {
        height = min(50, offset - 310);
      } else {
        height = 0;
      }
      _headerController.add(height);
    });
  }

  @override
  void dispose() {
    _headerController?.close();
    super.dispose();
    print("<> FirstTabBarView dispose");
  }

  @override
  Widget build(BuildContext context) {
    Widget child = NestedScrollView(
      key: PageStorageKey("FirstTabBarView"),
      controller: _scrollController1,
      physics: BouncingScrollPhysics(),
      headerSliverBuilder: (context, bool) {
        return [
          CupertinoSliverRefreshControl(
            onRefresh: () async {},
          ),
          SliverToBoxAdapter(
            child: Common.getWidget(1, iColor: Colors.red),
          ),
          DIYSliverPersistentHeader(
            pinned: true, //是否固定在顶部
            floating: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 50, //收起的高度
              maxHeight: 50, //展开的最大高度
              child: Container(
                color: Colors.grey,
                child: TabBar(
                  key: PageStorageKey("FirstTabBarView-TabBar"),
                  isScrollable: false,
                  controller: tabController1,
                  tabs: _tabs
                      .map((String name) => Container(
                            height: 50,
                            child: Text(
                              name,
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ];
      },
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream: offsetStream,
            builder: (context, value) {
              return Container(
                height: value.data,
                color: Colors.white,
              );
            },
          ),
          Expanded(
            child: TabBarView(
              key: PageStorageKey("FirstTabBarView-TabBarView"),
              controller: tabController1,
              physics: NeverScrollableScrollPhysics(),
              children: _tabs
                  .map((e) =>
                      SubTabListPage(widget.scrollController, _tabs.indexOf(e)))
                  .toList(),
            ),
          )
        ],
      ),
    );
//    child = NotificationListener<ScrollNotification>(
//      onNotification: (scroll) {
//        if (scroll is OverscrollNotification) {
//          print("<> NotificationListener OverscrollNotification");
//        }
//        return false;
//      },
//      child: child,
//    );
    return child;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
