import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/mock/img_mock.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StaggeredDemo extends StatefulWidget {
  @override
  _StaggeredDemoState createState() => _StaggeredDemoState();
}

class _StaggeredDemoState extends State<StaggeredDemo> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverStaggeredGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return CachedNetworkImage(
                imageUrl: mockImgs[index],
              );
            },
            childCount: mockImgs.length,
          ),
          gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 9,
            crossAxisSpacing: 9,
            staggeredTileBuilder: (index) {
              if (index >= mockImgs.length) return null;
              return StaggeredTile.fit(1);
            },
          ),
        ),
      ],
    );
  }
}
