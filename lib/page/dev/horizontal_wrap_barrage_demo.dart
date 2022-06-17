import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';

class HorizontalWrapBarrageDemo extends StatefulWidget {
  @override
  State<HorizontalWrapBarrageDemo> createState() =>
      _HorizontalWrapBarrageDemoState();
}

class _HorizontalWrapBarrageDemoState extends State<HorizontalWrapBarrageDemo> {
  ScrollController scrollController1;
  ScrollController scrollController2;
  ScrollController scrollController3;
  double offset = 0;
  Function scroll;
  Timer _timer;
  Random random = new Random();

  @override
  void initState() {
    super.initState();
    scrollController1 = ScrollController();
    scrollController2 = ScrollController();
    scrollController3 = ScrollController();
    scroll = () {
      offset += 100;
      scrollController1.animateTo(offset,
          duration: Duration(seconds: 1), curve: Curves.linear);
      scrollController2.animateTo(offset,
          duration: Duration(seconds: 1), curve: Curves.linear);
      scrollController3.animateTo(offset,
          duration: Duration(seconds: 1), curve: Curves.linear);
    };
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      scroll();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: false,
      child: Container(
        height: 200,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: scrollController1,
                itemBuilder: (context, index) {
                  return Common.getWidget(index,
                      height: 30, width: random.nextInt(100).toDouble());
                },
              ),
            ),
            Expanded(
                child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: scrollController2,
              itemBuilder: (context, index) {
                return Common.getWidget(index,
                    height: 30, width: random.nextInt(100).toDouble());
              },
            )),
            Expanded(
                child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: scrollController3,
              itemBuilder: (context, index) {
                return Common.getWidget(index,
                    height: 30, width: random.nextInt(100).toDouble());
              },
            ))
          ],
        ),
      ),
    );
  }
}
