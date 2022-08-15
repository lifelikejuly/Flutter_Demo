import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';

class NestedScrollDemo extends StatefulWidget {
  @override
  State<NestedScrollDemo> createState() => _NestedScrollDemoState();
}

class _NestedScrollDemoState extends State<NestedScrollDemo> {
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
