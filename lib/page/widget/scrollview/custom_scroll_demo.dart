import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';

class CustomScrollDemo extends StatefulWidget {
  @override
  State<CustomScrollDemo> createState() => _CustomScrollDemoState();
}

class _CustomScrollDemoState extends State<CustomScrollDemo> {
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
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
        SliverAppBar(
          pinned: _pinned,
          snap: _snap,
          floating: _floating,
          leading: SizedBox(),
          expandedHeight: 160.0,
          flexibleSpace: const FlexibleSpaceBar(
            title: Text('SliverAppBar1'),
            background: FlutterLogo(),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(10.0),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                      color: Colors.lightBlueAccent,
                    ),
                childCount: 15),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 5.0 / 2.0),
          ),
        ),
        SliverAppBar(
          pinned: _pinned,
          snap: _snap,
          floating: _floating,
          leading: SizedBox(),
          expandedHeight: 160.0,
          flexibleSpace: const FlexibleSpaceBar(
            title: Text('SliverAppBar'),
            background: FlutterLogo(),
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Common.getWidget(index);
            },
            childCount: 10,
          ),
          itemExtent: 40.0,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Common.getWidget(index);
            },
          ),
        ),
      ],
    );
  }
}
