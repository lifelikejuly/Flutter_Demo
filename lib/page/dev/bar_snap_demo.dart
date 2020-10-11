import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BarSnapDemo extends StatefulWidget {
  @override
  _BarSnapDemoState createState() => _BarSnapDemoState();
}

class _BarSnapDemoState extends State<BarSnapDemo>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollViewController;

  List<String> items = [];
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.blue,
    Colors.amber,
    Colors.cyan,
    Colors.pink
  ];
  Random random = new Random();

  Color getRandomColor() {
    return colors.elementAt(random.nextInt(colors.length));
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollViewController.dispose();
  }

  @override
  void initState() {
    for (var i = 0; i < 10; i++) {
      items.add('Item $i');
    }
    _tabController = TabController(vsync: this, length: 2);
    _scrollViewController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
//              SliverOverlapAbsorber(
//                handle:
//                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//                sliver: SliverAppBar(
//                  leading: Container(),
//                  expandedHeight: 200.0,
//                  title: Text(""),
//                  floating: true,
//                  pinned: true,
//                  flexibleSpace: FlexibleSpaceBar(
//                    collapseMode: CollapseMode.pin,
//                  ),
//                  bottom: PreferredSize(
//                    child: Container(
//                      alignment: Alignment.center,
//                      height: 50,
//                      width: MediaQuery.of(context).size.width,
//                      color: Colors.orange,
//                      child: Text("常驻在顶部的吸顶区域"),
//                    ),
//                    preferredSize: Size.fromHeight(50),
//                  ),
//                ),
//              ),
              SliverAppBar(
                leading: Container(),
                expandedHeight: 200.0,
                title: Text(""),
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                ),
                bottom: PreferredSize(
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.orange,
                    child: Text("常驻在顶部的吸顶区域"),
                  ),
                  preferredSize: Size.fromHeight(50),
                ),
              ),
            ];
          }, body: SafeArea(
            child: Builder(builder: (context) {
              return CustomScrollView(
                slivers: [
//                  SliverOverlapInjector(
//                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
//                        context),
//                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Color color = getRandomColor();
                        return Container(
                          height: 150.0,
                          color: color,
                          child: Text(
                            "Row $index",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                      childCount: 100,
                    ),
                  ),
                ],
              );
            }),
          )),
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: Container(),
                expandedHeight: 200.0,
                title: Text(""),
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                ),
                bottom: PreferredSize(
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.orange,
                    child: Text("常驻在顶部的吸顶区域"),
                  ),
                  preferredSize: Size.fromHeight(50),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Color color = getRandomColor();
                    return Container(
                      height: 150.0,
                      color: color,
                      child: Text(
                        "Row $index",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      //类似于Java开发Android中FrameLayout控件
      fit: StackFit.expand, //大小与父组件一样大
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            //装饰器
            gradient: LinearGradient(
              //线性渐变
              colors: [Colors.transparent, Colors.black54],
              stops: [0.5, 1.0],
              //渐变的取值
              //从上到下渐变
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.repeated,
            ),
          ),
        ),
        Positioned(
          //离左右下的边距
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
          child: Text(
            '我的相册',
            style: TextStyle(fontSize: 28.0, color: Colors.white),
          ),
        ),
      ],
    );
  }

  MySliverPersistentHeaderDelegate({
    this.minExtent,
    this.maxExtent,
  });

  double maxExtent;
  double minExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
