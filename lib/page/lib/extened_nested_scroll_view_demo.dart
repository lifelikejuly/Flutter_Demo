import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter/widgets.dart';


class OldExtendedNestedScrollViewDemo extends StatefulWidget {
  @override
  _OldExtendedNestedScrollViewDemoState createState() =>
      _OldExtendedNestedScrollViewDemoState();
}

class _OldExtendedNestedScrollViewDemoState
    extends State<OldExtendedNestedScrollViewDemo>
    with TickerProviderStateMixin {
  TabController primaryTC;
  TabController secondaryTC;

  @override
  void initState() {
    primaryTC = TabController(length: 2, vsync: this);
    primaryTC.addListener(tabControlerListener);
    secondaryTC = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    primaryTC.removeListener(tabControlerListener);
    primaryTC.dispose();
    secondaryTC.dispose();
    super.dispose();
  }

  //when primary tabcontroller tab,rebuild headerSliverBuilder
  //click fire twice (due to animation),gesture fire onetime
  int index;
  void tabControlerListener() {
    if (index != primaryTC.index) {
      //your code
      index = primaryTC.index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: null,
    );
  }

  // Widget _buildScaffoldBody() {
  //   final double statusBarHeight = MediaQuery.of(context).padding.top;
  //   final double pinnedHeaderHeight =
  //       //statusBar height
  //       statusBarHeight +
  //           //pinned SliverAppBar height in header
  //           kToolbarHeight;
  //   return NestedScrollViewRefreshIndicator(
  //     onRefresh: onRefresh,
  //     child: NestedScrollView(
  //         headerSliverBuilder: (BuildContext c, bool f) {
  //           return buildSliverHeader();
  //         },
  //         //1.[pinned sliver header issue](https://github.com/flutter/flutter/issues/22393)
  //         pinnedHeaderSliverHeightBuilder: () {
  //           return pinnedHeaderHeight;
  //         },
  //         //2.[inner scrollables in tabview sync issue](https://github.com/flutter/flutter/issues/21868)
  //         innerScrollPositionKeyBuilder: () {
  //           String index = 'Tab';
  //           if (primaryTC.index == 0) {
  //             index +=
  //                 primaryTC.index.toString() + secondaryTC.index.toString();
  //           } else {
  //             index += primaryTC.index.toString();
  //           }
  //           return Key(index);
  //         },
  //         body: Column(
  //           children: <Widget>[
  //             TabBar(
  //               controller: primaryTC,
  //               labelColor: Colors.blue,
  //               indicatorColor: Colors.blue,
  //               indicatorSize: TabBarIndicatorSize.label,
  //               indicatorWeight: 2.0,
  //               isScrollable: false,
  //               unselectedLabelColor: Colors.grey,
  //               tabs: const <Tab>[
  //                 Tab(text: 'Tab0'),
  //                 Tab(text: 'Tab1'),
  //               ],
  //             ),
  //             Expanded(
  //               child: TabBarView(
  //                 controller: primaryTC,
  //                 children: <Widget>[
  //                   SecondaryTabView('Tab0', secondaryTC, true),
  //                   NestedScrollViewInnerScrollPositionKeyWidget(
  //                     const Key('Tab1'),
  //                     GlowNotificationWidget(
  //                       ListView.builder(
  //                         //store Page state
  //                         key: const PageStorageKey<String>('Tab1'),
  //                         physics: const ClampingScrollPhysics(),
  //                         itemBuilder: (BuildContext c, int i) {
  //                           return Container(
  //                             alignment: Alignment.center,
  //                             height: 60.0,
  //                             child: Text(const Key('Tab1').toString() +
  //                                 ': ListView$i'),
  //                           );
  //                         },
  //                         itemCount: 50,
  //                       ),
  //                       showGlowLeading: false,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             )
  //           ],
  //         )),
  //   );
  // }

  Future<bool> onRefresh() {
    return Future<bool>.delayed(const Duration(seconds: 1), () {
      return true;
    });
  }

  List<Widget> buildSliverHeader() {
    final List<Widget> widgets = <Widget>[];

    widgets.add(SliverAppBar(
        pinned: true,
        expandedHeight: 200.0,
        //title: Text(old ? 'old demo' : 'new demo'),
        flexibleSpace: FlexibleSpaceBar(
          //centerTitle: true,
            collapseMode: CollapseMode.pin,
            background: Image.asset(
              'assets/467141054.jpg',
              fit: BoxFit.fill,
            ))));

    widgets.add(SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 0.0,
      ),
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            height: 60.0,
            child: Text('Gird$index'),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 1.0)),
          );
        },
        childCount: 7,
      ),
    ));

    widgets.add(SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext c, int i) {
          return Container(
            alignment: Alignment.center,
            height: 60.0,
            child: Text('SliverList$i'),
          );
        }, childCount: 3)));

//  widgets.add(SliverPersistentHeader(
//      pinned: true,
//      floating: false,
//      delegate: CommonSliverPersistentHeaderDelegate(
//          Container(
//            child: primaryTabBar,
//            //color: Colors.white,
//          ),
//          primaryTabBar.preferredSize.height)));
    return widgets;
  }
}

class SecondaryTabView extends StatefulWidget {
  const SecondaryTabView(this.tabKey, this.tc, this.oldDemo);
  final String tabKey;
  final TabController tc;
  final bool oldDemo;
  @override
  _SecondaryTabViewState createState() => _SecondaryTabViewState();
}

class _SecondaryTabViewState extends State<SecondaryTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final TabBar secondaryTabBar = TabBar(
      controller: widget.tc,
      labelColor: Colors.blue,
      indicatorColor: Colors.blue,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 2.0,
      isScrollable: false,
      unselectedLabelColor: Colors.grey,
      tabs: <Tab>[
        Tab(text: widget.tabKey + '0'),
        Tab(text: widget.tabKey + '1'),
        Tab(text: widget.tabKey + '2'),
        Tab(text: widget.tabKey + '3'),
      ],
    );
    return Column(
      children: <Widget>[
        secondaryTabBar,
        Expanded(
          child: TabBarView(
            controller: widget.tc,
            children: <Widget>[
              // TabViewItem(Key(widget.tabKey + '0'), widget.oldDemo),
              // TabViewItem(Key(widget.tabKey + '1'), widget.oldDemo),
              // TabViewItem(Key(widget.tabKey + '2'), widget.oldDemo),
              // TabViewItem(Key(widget.tabKey + '3'), widget.oldDemo),
            ],
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
// class TabViewItem extends StatefulWidget {
//   const TabViewItem(this.tabKey, this.oldDemo);
//   final Key tabKey;
//   final bool oldDemo;
//   @override
//   _TabViewItemState createState() => _TabViewItemState();
// }

// class _TabViewItemState extends State<TabViewItem>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final GlowNotificationWidget child = GlowNotificationWidget(
//       //margin: EdgeInsets.only(left: 190.0),
//       ListView.builder(
//           physics: const ClampingScrollPhysics(),
//           itemBuilder: (BuildContext c, int i) {
//             return Container(
//               //decoration: BoxDecoration(border: Border.all(color: Colors.orange,width: 1.0)),
//               alignment: Alignment.center,
//               height: 60.0,
//               width: double.infinity,
//               //color: Colors.blue,
//               child: Text(widget.tabKey.toString() + ': List$i'),
//             );
//           },
//           itemCount: 100,
//           padding: const EdgeInsets.all(0.0)),
//       showGlowLeading: false,
//     );
//
//     if (widget.oldDemo) {
//       return NestedScrollViewInnerScrollPositionKeyWidget(widget.tabKey, child);
//     }
//
//     /// new one doesn't need NestedScrollViewInnerScrollPositionKeyWidget any more.
//     else {
//       return child;
//     }
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }

class GlowNotificationWidget extends StatelessWidget {
  /// Whether to show the overscroll glow on the side with negative scroll
  /// offsets.
  final bool showGlowLeading;

  /// Whether to show the overscroll glow on the side with positive scroll
  /// offsets.
  final bool showGlowTrailing;

  //scrollable child
  final Widget child;
  GlowNotificationWidget(this.child,
      {this.showGlowLeading: false, this.showGlowTrailing: false});
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleGlowNotification, child: child);
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    if ((notification.leading && !showGlowLeading) ||
        (!notification.leading && !showGlowTrailing)) {
      notification.disallowGlow();
      return true;
    }
    return false;
  }
}