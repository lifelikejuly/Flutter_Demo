import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/diy_refresh.dart';
import 'package:flutter_demo/page/common/common.dart';

import 'NestedClampingScrollPhysics.dart';

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
      physics: NestedClampingScrollPhysics(),
      slivers: <Widget>[
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
        // SliverList(
        //   delegate: SliverChildBuilderDelegate(
        //     (context, index) {
        //       return Common.getWidget(index);
        //     },
        //   ),
        // ),
        SliverFillRemaining(
          child:  TestViewDemo(),
          fillOverscroll: true,
          hasScrollBody: true,
        ),
      ],
    );
  }
}


class TestViewDemo extends StatefulWidget {

  @override
  State<TestViewDemo> createState() => _TestViewDemoState();
}

class _TestViewDemoState extends State<TestViewDemo> with TickerProviderStateMixin{


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // return DefaultTabController(length: 3, child:TabBarView(
    //   children: [
    //     Container(
    //       height: 1200,
    //       color: Colors.black,
    //       child: Text("1"),
    //     ),
    //     Container(
    //       height: 1200,
    //       color: Colors.red,
    //       child: Text("2"),),
    //     Container(
    //         height: 1200,
    //         color: Colors.green,
    //         child: Text("3")),
    //   ],
    // ));
    return DefaultTabController(length: 3, child: SizedBox(
      child:  TabBarView(
        children: [
          SizedBox(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              // controller: ScrollController(),
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context,index){
                return Text("显示不全 100 $index");
              },
              itemCount: 100,
            ),
          ),
          SizedBox(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context,index){
                return Text("$index");
              },
              itemCount: 100,
            ),),
          SizedBox(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context,index){
                return Text("$index");
              },
              itemCount: 100,
            ),),
        ],
      ),
    ));
  }
}
