import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/diy_sliver_border.dart';
import 'package:flutter_demo/page/common/common.dart';

class SliverBorderDemo extends StatefulWidget {
  @override
  _SliverBorderDemoState createState() => _SliverBorderDemoState();
}

class _SliverBorderDemoState extends State<SliverBorderDemo> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.center,
            child: Text("xixixix", style: TextStyle(color: Colors.white)),
            width: double.infinity,
            height: 200,
            color: Colors.pink,
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 100),
          sliver: SliverContainer(
            container: Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (content, index) {
                  return Common.getWidget(index);
                },
                childCount: 5,
              ),
            ),
          ),
        ),
        SliverContainer(
          container: Container(
            padding: EdgeInsets.only(left: 20, top: 100, right: 20),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (content, index) {
                return Common.getWidget(index);
              },
              childCount: 5,
            ),
          ),
        ),
      ],
    );
  }
}
