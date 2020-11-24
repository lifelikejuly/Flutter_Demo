import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';

class ListJumpInitDemo extends StatefulWidget {
  @override
  _ListJumpInitDemoState createState() => _ListJumpInitDemoState();
}

class _ListJumpInitDemoState extends State<ListJumpInitDemo>
    with TickerProviderStateMixin {
  ScrollController scrollController;
  PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                print("<ListJumpInitDemo> ListView $index");
                return Common.getWidget(index);
              },
              itemCount: 100,
              controller: scrollController,
            ),
          ),
          Container(
            height: 200,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                print("<ListJumpInitDemo> PageView $index");
                return Container(
                  width: 200,
                  height: 200,
                  child: Common.getWidget(index),
                );
              },
              itemCount: 100,
              controller: pageController,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController =
        ScrollController(initialScrollOffset: 1000, keepScrollOffset: false);
    pageController = PageController(initialPage: 50);
  }
}
