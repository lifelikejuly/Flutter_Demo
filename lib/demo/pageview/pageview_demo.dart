import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_demo/demo/pageview/pageview_demo5.dart';
import 'package:flutter_demo/demo/pageview/pageview_demo6.dart';

import 'costom_page_view.dart';
import 'pageview_demo4.dart';
import 'pageview_demo2.dart';
import 'pageview_demo3.dart';
import 'paging_scroll_physics.dart';

class PageSelectListDemo extends StatefulWidget {
  @override
  _PageSelectListDemoState createState() => _PageSelectListDemoState();
}

class _PageSelectListDemoState extends State<PageSelectListDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          FlatButton(
            child: Text("PageView"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => PageViewDemo(),
                ),
              );
            },
          ),
          FlatButton(
            child: Text("ListViewFakePageView"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ListViewFakeDemo(),
                ),
              );
            },
          ),
          FlatButton(
            child: Text("PageView-Demo2"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => IntroPageView(),
                ),
              );
            },
          ),
          FlatButton(
            child: Text("PageView-Demo3"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => PageViewDemo3(),
                ),
              );
            },
          ),
          FlatButton(
            child: Text("PageView-Demo4"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ExampleCustom(),
                ),
              );
            },
          ),
          FlatButton(
            child: Text("PageView-Demo5"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => PageViewDemo5(),
                ),
              );
            },
          ),
          FlatButton(
            child: Text("PageView-Demo6"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => PageViewDemo6(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ListViewFakeDemo extends StatefulWidget {
  @override
  _ListViewFakeDemoState createState() => _ListViewFakeDemoState();
}

class _ListViewFakeDemoState extends State<ListViewFakeDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            height: 1.38 * 100,
            child: Center(child: Text("$index")),
//            duration: Duration(milliseconds: 500),
//            curve: Curves.easeOutQuint,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.deepOrange.withRed(10 + index * 10),
            ),
          );
        },
        physics: PagingScrollPhysics(
          maxSize: 1000000,
          leadingSpacing: 10,
          itemDimension: 50,
        ),
      ),
    );
  }
}

class PageViewDemo extends StatefulWidget {
  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  CustomPageController customPageController;
  int position = 0;
  var pageOffset = 0.0;

  @override
  void initState() {
    super.initState();
    customPageController = CustomPageController(
      initialPage: 2000000000 ~/ 2,
      viewportFraction: 0.5,
      keepPage: false,
    );

    customPageController.addListener(() {
      setState(() {
        pageOffset = customPageController.page;
        print(
            "WdbPageView ------------ \n ${customPageController.page} pageOffset $pageOffset --- ${customPageController.offset}");
      });
    });

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      pageOffset = customPageController.page;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: CustomPageView.custom(
          childrenDelegate: SliverChildBuilderDelegate(
            (context, index) {
              var currentLeftPageIndex = pageOffset.floor();
              var currentPageOffsetPercent = pageOffset - currentLeftPageIndex;
              return Transform.scale(
                scale: _calScale(
                    currentLeftPageIndex, index, currentPageOffsetPercent),
                child: Container(
                  color: Colors.deepOrange,
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ContentView(index % 10),
                    ],
                  ),
                ),
              );
            },
            childCount: 2000000000,
          ),
          controller: customPageController,
          onPageChanged: (position) {
            this.position = position;
            setState(() {});
          },
        ),
      ),
    );
  }

  double _calScale(int currentPosition, int thisPosition, double pre) {
    if (thisPosition == currentPosition) {
      return 1 - pre / 5;
    } else if (thisPosition == currentPosition + 1) {
      return 4 / 5 + pre / 5;
    } else {
      return 4 / 5;
    }
//
//    if (thisPosition == currentPosition) {
//      return 1 - pre / 5;
//    } else if (thisPosition == currentPosition + 1) {
//      return 4 / 5 ;
//    } else {
//      return 4 / 5;
//    }
  }
}

class ContentView extends StatelessWidget {
  final int index;

  ContentView(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.deepOrange.withRed(10 + index * 10),
      child: Center(
        child: Text('$index',
            style: TextStyle(fontSize: 64.0, color: Colors.white)),
      ),
    );
  }
}
