import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';

class SliverListDemo extends StatefulWidget {
  @override
  _SliverListDemoState createState() => _SliverListDemoState();
}

class _SliverListDemoState extends State<SliverListDemo> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
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
