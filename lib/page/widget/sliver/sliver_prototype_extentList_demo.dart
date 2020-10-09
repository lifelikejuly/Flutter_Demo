import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';

class SliverPrototypeExtentListDemo extends StatefulWidget {
  @override
  _SliverPrototypeExtentListDemoState createState() =>
      _SliverPrototypeExtentListDemoState();
}

class _SliverPrototypeExtentListDemoState
    extends State<SliverPrototypeExtentListDemo> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPrototypeExtentList(
          prototypeItem: Container(
            height: 100,
            child: Text(
              'SliverPrototypeExtentList',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
          delegate: SliverChildBuilderDelegate(
            (content, index) {
              return Common.getWidget(index);
            },
            childCount: 50,
            addRepaintBoundaries: true,
          ),
        ),
      ],
    );
  }
}
