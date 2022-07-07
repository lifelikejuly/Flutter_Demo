import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';

import 'diy_list_wheel_scroll_view.dart';

class ListWheelDiyDemo extends StatefulWidget {
  @override
  State<ListWheelDiyDemo> createState() => _ListWheelDiyDemoState();
}

class _ListWheelDiyDemoState extends State<ListWheelDiyDemo> {
  DIYFixedExtentScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = DIYFixedExtentScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: DIYListWheelScrollView.useDelegate(
            controller: scrollController,
            physics: DIYFixedExtentScrollPhysics(),
            squeeze: 0.65,
            itemExtent: 100,
            onSelectedItemChanged: (index) {
              print("ListWheelScrollView onSelectedItemChanged $index");
            },
            clipBehavior: Clip.none,
            childDelegate: DIYListWheelChildLoopingListDelegate(
              children: List.generate(5, (index) {
                return Container(
                  // color: Colors.blue,
                  alignment: Alignment.center,
                  width: 244,
                  height: 377,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset("images/p${index + 1}.jpeg"),
                      Text(
                        "$index",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
        GestureDetector(
          child: Text("test"),
          onTap: () {
            scrollController.jumpTo(200);
          },
        )
      ],
    );
  }
}
