import 'dart:math';

import 'package:flutter/material.dart';

class SliverTabBarDemo2 extends StatefulWidget {
  @override
  _SliverTabBarDemoState createState() => _SliverTabBarDemoState();
}

class _SliverTabBarDemoState extends State<SliverTabBarDemo2>
    with SingleTickerProviderStateMixin {
//  TabController _tabController; // To control switching tabs
  ScrollController _scrollViewController; // To control scrolling
//
//  List<String> items = [];
//  List<Color> colors = [
//    Colors.red,
//    Colors.green,
//    Colors.yellow,
//    Colors.purple,
//    Colors.blue,
//    Colors.amber,
//    Colors.cyan,
//    Colors.pink
//  ];
//  Random random = new Random();
//
//  Color getRandomColor() {
//    return colors.elementAt(random.nextInt(colors.length));
//  }

  @override
  void initState() {
    super.initState();
//    _tabController = TabController(vsync: this, length: 2);
    _scrollViewController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
//    _tabController.dispose();
//    _scrollViewController.dispose();
  }

  //例子2
  @override
  Widget build(BuildContext context) {
    Widget scrollView = CustomScrollView(
//      controller: _scrollViewController,
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 4.0,
          ),
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.teal[100 * (index % 9)],
                child: Text('grid item $index'),
              );
            },
            childCount: 20,
          ),
        ),
        SliverFixedExtentList(
          itemExtent: 50.0,
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.lightBlue[100 * (index % 9)],
                child: Text('list item $index'),
              );
            },
          ),
        ),
      ],
    );
    Widget body = NestedScrollView(
//      controller: _scrollViewController,
      scrollDirection: Axis.vertical,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Fuck"),
            ),
            bottom: PreferredSize(
              child: Text(
                "Fuck God",
              ),
              preferredSize: Size.fromHeight(50),
            ),
          ),
        ];
      },
      body: scrollView,
    );


    return Scaffold(
      body: body,
    );
  }
}
