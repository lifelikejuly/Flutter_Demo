import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/diy_sliver_header.dart';
import 'package:flutter_demo/mock/img_mock.dart';
import 'package:flutter_demo/page/common/common.dart';
import 'package:flutter_demo/page/dev/flex_tabbar_page_demo1/sub_tab_list_page.dart';
import 'package:flutter_demo/page/lib/waterfall/src/rendering/sliver_waterfall_flow.dart';
import 'package:flutter_demo/page/lib/waterfall/src/widgets/scroll_view.dart';
import 'package:flutter_demo/page/lib/waterfall/src/widgets/sliver.dart';

import 'simple_tab_bar_page.dart';


// 一个复杂的列表结构布局
// 实现一级头部视图上滑隐藏
// 一级Tab置顶和二级tab置顶效果
// 二级tab下的列表刷新问题



class ComplexPageDemo1 extends StatefulWidget {
  @override
  _ComplexPageDemo1State createState() => _ComplexPageDemo1State();
}

class _ComplexPageDemo1State extends State<ComplexPageDemo1>
    with TickerProviderStateMixin {
  ScrollController scrollController;
  TabController tabController1;
  List<String> _tabs = [
    "关注",
    "发现",
    "Tab1",
    "Tab2",
    "Tab3",
  ];

  @override
  void initState() {
    super.initState();
    tabController1 = TabController(length: _tabs.length, vsync: this);
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: scrollController,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            pinned: true,
            forceElevated: innerBoxIsScrolled,
            elevation: 0,
            backgroundColor:  Colors.white,
            flexibleSpace: PreferredSize(
              child: AppBar(
                backgroundColor: Colors.transparent,
                titleSpacing: 0.0,
                automaticallyImplyLeading: false,
                title: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Header View",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              preferredSize: Size.fromHeight(44),
            ),
            bottom: PreferredSize(
              child: Container(
                color: Colors.black,
                child: TabBar(
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
              preferredSize: Size.fromHeight(52),
            ),
          ),
        ];
      },
      body: TabBarView(
        key: PageStorageKey("FirstTabBarView-TabBarView"),
        controller: tabController1,
        physics: NeverScrollableScrollPhysics(),
        children: [
          FirstTabBarView(scrollController),
          SimpleTabBarView(1),
          SimpleTabBarView(2),
          SimpleTabBarView(3),
          SimpleTabBarView(4),
        ],
      ),
    );
  }
}
