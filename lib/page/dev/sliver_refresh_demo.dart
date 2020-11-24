import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/diy_refresh.dart';
import 'package:flutter_demo/page/common/common.dart';



class SliverRefreshDemo extends StatefulWidget {
  @override
  _SliverRefreshDemoState createState() => _SliverRefreshDemoState();
}

class _SliverRefreshDemoState extends State<SliverRefreshDemo> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        DIYCupertinoSliverRefreshControl(
          onRefresh: () async {

          },
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (content, index) {
              return Common.getWidget(index);
            },
            childCount: 100,
          ),
        )
      ],
    );
  }
}
