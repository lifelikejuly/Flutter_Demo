import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/side_pull_indicator.dart';

class SidePullDemo extends StatefulWidget {
  @override
  _SidePullDemoState createState() => _SidePullDemoState();
}

class _SidePullDemoState extends State<SidePullDemo> {
  int lengthCount = 20;

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.blue,
    Colors.amber,
    Colors.cyan,
    Colors.pink
  ];
  Random random = new Random();

  Color getRandomColor() {
    return colors.elementAt(random.nextInt(colors.length));
  }

  _childContent() {
    return ListView.builder(
      itemBuilder: (context, index) {
        Color color = getRandomColor();
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 175,
          width: 100,
          color: color,
          alignment: Alignment.center,
          child: Text(
            "$index",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      itemCount: lengthCount,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 175,
          child: SidePullIndicator(
            child: _childContent(),
            onRefresh: () async {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("触发了~~~！！！"),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
