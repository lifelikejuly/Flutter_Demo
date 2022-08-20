import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';
import 'page1.dart';
import 'page2.dart';
import 'page3.dart';
import 'shop/shop_scroll_coordinator.dart';

import 'shop/shop_scroll_controller.dart';

///https://juejin.cn/post/6844904061632774157
///
class ShopPageDemo extends StatefulWidget {
  ShopPageDemo({Key key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPageDemo>
    with SingleTickerProviderStateMixin {
  ///页面滑动协调器
  ShopScrollCoordinator _shopCoordinator;
  ShopScrollController _pageScrollController;

  TabController _tabController;

  final double _sliverAppBarInitHeight = 500;
  final double _tabBarHeight = 50;
  double _sliverAppBarMaxHeight;

  @override
  void initState() {
    super.initState();
    _shopCoordinator = ShopScrollCoordinator();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height;
    double statusBarHeight = mediaQuery.padding.top;

    _sliverAppBarMaxHeight ??= screenHeight;

    // _pageScrollController ??= _shopCoordinator
    //     .pageScrollController(_sliverAppBarMaxHeight - _sliverAppBarInitHeight);
    //
    // _shopCoordinator.pinnedHeaderSliverHeightBuilder ??= () {
    //   return statusBarHeight + kToolbarHeight + _tabBarHeight;
    // };

    _pageScrollController ??= _shopCoordinator
        .pageScrollController(0);

    // _shopCoordinator.pinnedHeaderSliverHeightBuilder ??= () {
    //   return 400;
    // };
    Widget child  = CustomScrollView(
      controller: _pageScrollController,
      physics: ClampingScrollPhysics(),
      slivers: <Widget>[
        // SliverAppBar(
        //   pinned: true,
        //   title: Text("店铺首页", style: TextStyle(color: Colors.white)),
        //   backgroundColor: Colors.blue,
        //   expandedHeight: _sliverAppBarMaxHeight,
        //   leading: null,
        //
        // ),
        // SliverPersistentHeader(
        //   pinned: false,
        //   floating: true,
        //   delegate: _SliverAppBarDelegate(
        //     maxHeight: 200,
        //     minHeight: 200,
        //     child: Center(child: Text("我是活动Header")),
        //   ),
        // ),
        // SliverPersistentHeader(
        //   pinned: true,
        //   floating: false,
        //   delegate: _SliverAppBarDelegate(
        //     maxHeight: _tabBarHeight,
        //     minHeight: _tabBarHeight,
        //     child: Container(
        //       color: Colors.white,
        //       child: TabBar(
        //         labelColor: Colors.black,
        //         controller: _tabController,
        //         tabs: <Widget>[
        //           Tab(text: "商品"),
        //           Tab(text: "评价"),
        //           Tab(text: "商家"),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),

        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return Common.getWidget(index);
            },
            childCount: 10,
          ),
          itemExtent: 40.0,
        ),
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Page1(shopCoordinator: _shopCoordinator),
              Page2(shopCoordinator: _shopCoordinator),
              Page3(),
            ],
          ),
        )
      ],
    );
    return Listener(
        onPointerUp: _shopCoordinator.onPointerUp,
        child:child,
      );
    // return child;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _pageScrollController?.dispose();
    super.dispose();
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
  double get minExtent => this.minHeight;

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
