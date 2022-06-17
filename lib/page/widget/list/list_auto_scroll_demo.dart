import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';

class ListAutoScrollDemo extends StatefulWidget {
  @override
  State<ListAutoScrollDemo> createState() => _ListAutoScrollDemoState();
}

class _ListAutoScrollDemoState extends State<ListAutoScrollDemo> {
  ScrollController scrollController;
  double offset = 0;
  Function scroll;

  Timer _timer;
  Timer _timer2;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scroll = () {
      offset += 100;
      scrollController.animateTo(offset,
          duration: Duration(seconds: 2), curve: Curves.linear);
    };
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      scroll();
    });
  }



  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer2?.cancel();
  }

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: (){

        // _timer2?.cancel();
        // _timer2 = Timer(Duration(seconds: 2),() {
        //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        //     scroll();
        //   });
        // });
      },
      onTapUp: (details){
        _timer?.cancel();
        Timer(Duration(milliseconds: 100),() {
          GestureBinding.instance.handlePointerEvent(PointerAddedEvent(pointer: 0,position: details.globalPosition));
          GestureBinding.instance.handlePointerEvent(PointerDownEvent(pointer: 0,position: details.globalPosition));
          GestureBinding.instance.handlePointerEvent(PointerUpEvent(pointer: 0,position: details.globalPosition));
        });
      },
      onTapDown: (details){
        // print("${details.globalPosition.toString()}");


      },
      child: ListView.builder(
        controller: scrollController,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Common.getWidget(index),
            onTap: () {
              print("<> index $index");
              _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                scroll();
              });
            },
            // onTapDown: (_) {
            //   print("<> onTapDown index $index");
            // },
          );
          // return Common.getWidget(index);
        },
      ),
    );
  }
}

class XNeverScrollableScrollPhysics extends ScrollPhysics {
  /// Creates scroll physics that does not let the user scroll.
  const XNeverScrollableScrollPhysics({ScrollPhysics parent})
      : super(parent: parent);

  @override
  XNeverScrollableScrollPhysics applyTo(ScrollPhysics ancestor) {
    return XNeverScrollableScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => false;

  @override
  bool get allowImplicitScrolling => true;
}
