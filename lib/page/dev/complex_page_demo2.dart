import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const _tabs = [
  'Apple',
  'Banana',
  'Cherry',
];
const String _appBarTitle = 'Fruits';

class StickyTabsPage extends StatelessWidget {
  const StickyTabsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(_appBarTitle), elevation: 0.0),
        body: DefaultTabController(
            length: _tabs.length, // This is the number of tabs.
            child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Container(
                          color: Colors.grey,
                          height: 220.0,
                          child: Center(
                              child: const Text('fluttertutorial.in',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24.0))))
                    ])),
                    SliverPersistentHeader(
                        pinned: true,
                        delegate: _StickyTabBarDelegate(TabBar(
                            tabs: _tabs
                                .map((String name) => Tab(text: name))
                                .toList())))
                  ];
                },
                body: TabBarView(
                  children: _tabs.map((String name) {
                    return SafeArea(
                        child: ListView.builder(
                            key: PageStorageKey(name),
                            itemCount: 30,
                            itemBuilder: (context, index) {
                              return ListTile(title: Text('Item $index'));
                            }));
                  }).toList(),
                ))));
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.blue, child: tabBar);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}

class NestedScrollViewSamplePage extends StatelessWidget {
  const NestedScrollViewSamplePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            length: _tabs.length,
            child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        child: SliverAppBar(
                            title: const Text(_appBarTitle),
                            pinned: true,
                            expandedHeight: 150.0,
                            forceElevated: innerBoxIsScrolled,
                            bottom: TabBar(
                                tabs: _tabs
                                    .map((String name) => Tab(text: name))
                                    .toList())))
                  ];
                },
                body: TabBarView(
                  children: _tabs.map((String name) {
                    return SafeArea(
                        top: false,
                        bottom: false,
                        child: Builder(builder: (BuildContext context) {
                          return CustomScrollView(
                              key: PageStorageKey<String>(name),
                              slivers: <Widget>[
                                SliverOverlapInjector(
                                    handle: NestedScrollView
                                        .sliverOverlapAbsorberHandleFor(
                                            context)),
                                SliverPadding(
                                    padding: const EdgeInsets.all(8.0),
                                    sliver: SliverFixedExtentList(
                                        itemExtent: 48.0,
                                        delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index) {
                                          return ListTile(
                                              title: Text('Item $index'));
                                        }, childCount: 30)))
                              ]);
                        }));
                  }).toList(),
                ))));
  }
}
