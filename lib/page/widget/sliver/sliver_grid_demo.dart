import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';

class SliverGridDemo extends StatefulWidget {
  @override
  _SliverGridDemoState createState() => _SliverGridDemoState();
}

class _SliverGridDemoState extends State<SliverGridDemo> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 2,
            crossAxisCount: 4,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Common.getWidget(index);
            },
            childCount: 100
          ),
        ),

        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 2,
            crossAxisCount: 2,
          ),
          delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Common.getWidget(index);
              },
              childCount: 100
          ),
        ),
      ],
    );
  }
}
