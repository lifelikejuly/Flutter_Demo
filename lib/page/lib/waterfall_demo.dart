import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_demo/mock/img_mock.dart';

import 'waterfall/src/rendering/sliver_waterfall_flow.dart';
import 'waterfall/src/widgets/sliver.dart';

class WaterFallDemo extends StatefulWidget {
  @override
  _WaterFallDemoState createState() => _WaterFallDemoState();
}

class _WaterFallDemoState extends State<WaterFallDemo> {
  List<Color> colors = <Color>[];

  List<String> mockImags = List();

  @override
  void initState() {
    super.initState();
    mockImags = List.of(mockImgs,growable: true);
  }
  

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverWaterfallFlow(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              Widget child = CachedNetworkImage(
                imageUrl: mockImags[index],
              );
              child = GestureDetector(
                child: child,
                onTap: () async {
//                  var result = await Navigator.of(context).push(
//                    MaterialPageRoute(
//                      builder: (BuildContext context) => Scaffold(appBar: AppBar(title: Text("第二个页面"),),body: WaterFallDemo(),),
//                    ),
//                  );
                  mockImags.insert(index, mockImags[index]);
                  setState(() {});
                },
              );
              return child;
            },
            childCount: mockImags.length,
          ),
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 9,
            crossAxisSpacing: 9,
          ),
        ),
      ],
    );
//    final double screenWidthSize = MediaQuery.of(context).size.width;
//    final double screenHeightSize = MediaQuery.of(context).size.height;
//    int _crossAxisCount = 0;
//    if (screenWidthSize > 720) {
//      _crossAxisCount = 3;
//    } else if (screenWidthSize > 520) {
//      _crossAxisCount = 2;
//    } else {
//      _crossAxisCount = 1;
//    }
//    return CustomScrollView(
//      slivers: [
//        SliverToBoxAdapter(
//          child: Container(
//            height: 100.0,
//            child: Text('TEST'),
//          ),
//        ),
//        SliverPadding(
//          padding: EdgeInsets.all(5.0),
//          sliver: SliverWaterfallFlow(
//            gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
//              crossAxisCount: _crossAxisCount,
//              crossAxisSpacing: 4,
//              mainAxisSpacing: 4,
//            ),
//            delegate: SliverChildBuilderDelegate(
//                  (BuildContext c, int index) {
//                final Color color = getRandomColor(index);
//                return Container(
//                  decoration: BoxDecoration(
//                      border: Border.all(color: Colors.black),
//                      color: getRandomColor(index)),
//                  alignment: Alignment.center,
//                  child: Text(
//                    '$index ' + 'TestString' * 10 * (index % 3 + 1),
//                    style: TextStyle(
//                        color: color.computeLuminance() < 0.5
//                            ? Colors.white
//                            : Colors.black),
//                  ),
//                  //height: ((index % 3) + 1) * 100.0,
//                );
//              },
//              childCount: 22,
//            ),
//          ),
//        ),
//      ],
//    );
  }

  Color getRandomColor(int index) {
    if (index >= colors.length) {
      colors.add(Color.fromARGB(255, Random.secure().nextInt(255),
          Random.secure().nextInt(255), Random.secure().nextInt(255)));
    }

    return colors[index];
  }
}
