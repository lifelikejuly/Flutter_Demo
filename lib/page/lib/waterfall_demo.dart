import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/mock/img_mock.dart';

import 'waterfall/src/rendering/sliver_waterfall_flow.dart';
import 'waterfall/src/widgets/sliver.dart';

class WaterFallDemo extends StatefulWidget {
  @override
  _WaterFallDemoState createState() => _WaterFallDemoState();
}

class _WaterFallDemoState extends State<WaterFallDemo> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverWaterfallFlow(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return CachedNetworkImage(
                imageUrl: mockImgs[index],
              );
            },
            childCount: mockImgs.length,
          ),
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 9,
            crossAxisSpacing: 9,
          ),
        ),
      ],
    );
  }
}
