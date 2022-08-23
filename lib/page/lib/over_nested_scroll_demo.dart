import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/magic/diy_refresh.dart';
import 'package:flutter_demo/page/common/common.dart';

import 'over_nested_scroll/src/nested_scroll_view.dart';

class OverNestedScrollDemo extends StatefulWidget {
  @override
  State<OverNestedScrollDemo> createState() => _OverNestedScrollDemoState();
}

class _OverNestedScrollDemoState extends State<OverNestedScrollDemo> {
  @override
  Widget build(BuildContext context) {
    return TabBarViewOverNestedScroll();
  }
}

class TabBarViewOverNestedScroll extends StatelessWidget {
  ///Header collapsed height
  final minHeight = 120.0;

  ///Header expanded height
  final maxHeight = 400.0;

  @override
  Widget build(BuildContext context) {
    final List<String> _tabs = <String>['Tab 1', 'Tab 2'];

    final tabBar = TabBar(
      tabs: <Widget>[Text('Tab1'), Text('Tab2')],
    );
    final topHeight = MediaQuery.of(context).padding.top;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: CustomNestedScrollView(
              overscrollType: CustomOverscroll.outer,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              headerSliverBuilder: (context, innerScrolled) => <Widget>[
                    DIYCupertinoSliverRefreshControl(
                      onRefresh: () async {},
                    ),
                // CupertinoSliverRefreshControl(),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20,
                        child: Center(
                            child: const Text(
                                'Scroll to see the SliverAppBar in effect.')),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 200,
                        child: Center(child: const Text('I Am Empty')),
                      ),
                    ),
                    // 收起不占用高度
                    // SliverAppBar(
                    //   pinned: true,
                    //   snap: true,
                    //   floating: true,
                    //   leading: SizedBox(),
                    //   expandedHeight: 160.0,
                    //   flexibleSpace: const FlexibleSpaceBar(
                    //     title: Text('SliverAppBar'),
                    //     background: FlutterLogo(),
                    //   ),
                    // ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: CustomDelegate(),
                    ),
                  ],
              body: TabBarView(
                children: _tabs.map((String name) {
                  return SafeArea(
                    top: false,
                    bottom: false,
                    child: Builder(
                      builder: (BuildContext context) {
                        return ListView.builder(
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Common.getWidget(index);
                          },
                          itemCount: 100,
                        );
                      },
                    ),
                  );
                }).toList(),
              )),
        ));
  }
}

class CustomDelegate extends SliverPersistentHeaderDelegate {
  /// 最大高度
  @override
  double get maxExtent => 400;

  /// 最小高度
  @override
  double get minExtent => 100;

  /// shrinkOffset: 当前 sliver 顶部越过屏幕顶部的距离
  /// overlapsContent: 下方是否还有 content 显示
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Image.network(
      'https://pic1.zhimg.com/80/v2-fc35089cfe6c50f97324c98f963930c9_720w.jpg',
      fit: BoxFit.cover,
    );
  }

  /// 是否需要刷新
  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return maxExtent != oldDelegate.maxExtent ||
        minExtent != oldDelegate.minExtent;
  }
}
