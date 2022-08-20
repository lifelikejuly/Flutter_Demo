import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/diy_refresh.dart';
import 'package:flutter_demo/magic/scrollview/magic_nested_scroll_view.dart' hide SliverOverlapAbsorber,SliverOverlapInjector;
import 'package:flutter_demo/page/common/common.dart';

import 'NestedClampingScrollPhysics.dart';

class NestedScrollDemo extends StatefulWidget {
  @override
  State<NestedScrollDemo> createState() => _NestedScrollDemoState();
}

class _NestedScrollDemoState extends State<NestedScrollDemo> {
  @override
  Widget build(BuildContext context) {
    return NormalNestedScroll();
    // return OfficialNestedScroll();
    // return NestedScrollWithSliverOverlapAbsorber();
    // return TabBarViewMagicNestedScroll();
    // return TabBarViewOverNestedScroll();
  }
}

class OfficialNestedScroll extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final List<String> _tabs = <String>['Tab 1', 'Tab 2'];
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.child: Scaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: const Text('Books'),
                pinned: true,
                leading: null,
                expandedHeight: 150.0,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: _tabs.map((String name) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<String>(name),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: SliverFixedExtentList(
                          itemExtent: 48.0,
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              // This builder is called for each child.
                              // In this example, we just number each list item.
                              return ListTile(
                                title: Text('Item $index'),
                              );
                            },
                            childCount: 100,
                          ),
                        ),
                      ),
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





class TabBarViewMagicNestedScroll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> _tabs = <String>['Tab 1', 'Tab 2'];
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.child: Scaffold(
      child: MagicNestedScrollView(
        physics: NestedClampingScrollPhysics(),
        controller: ScrollController(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            DIYCupertinoSliverRefreshControl(
              onRefresh: () async {

              },
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
                child: Center(
                    child: const Text('Scroll to see the SliverAppBar in effect.')),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: Center(child: const Text('I Am Empty')),
              ),
            ),
          ];
        },
        // body: Text("kkkkk"),
        body: TabBarView(
          children: _tabs.map((String name) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return ListView.builder(
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context,index){
                      return Common.getWidget(index);
                    },
                    itemCount: 100,
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

class NormalNestedScroll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            title: Text('Snapping Nested SliverAppBar 300'),
            floating: false,
            snap: false,
            pinned: true,
            expandedHeight: 300.0,
            forceElevated: innerBoxIsScrolled,
            leading: SizedBox(),
          ),
        ];
      },
      body: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverFixedExtentList(
                itemExtent: 48.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Common.getWidget(index);
                  },
                  childCount: 40,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class NestedScrollWithSliverOverlapAbsorber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              title: Text('Snapping Nested SliverAppBar'),
              floating: false,
              snap: false,
              pinned: true,
              expandedHeight: 200.0,
              forceElevated: innerBoxIsScrolled,
              leading: SizedBox(),
            ),
          )
        ];
      },
      body: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
              SliverFixedExtentList(
                itemExtent: 48.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Common.getWidget(index);
                  },
                  childCount: 30,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
