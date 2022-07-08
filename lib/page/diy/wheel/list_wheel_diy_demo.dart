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


    print("<> build MediaQuery.of(context).size ${MediaQuery.of(context).size}");

    return Stack(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.yellow,
          child: DIYListWheelScrollView.useDelegate(
            renderChildrenOutsideViewport: false,
            controller: scrollController,
            physics: DIYFixedExtentScrollPhysics(),
            squeeze: 0.5,
            itemExtent: 100,
            onSelectedItemChanged: (index) {
              print("ListWheelScrollView onSelectedItemChanged $index");
            },
            clipBehavior: Clip.none,
            childDelegate: DIYListWheelChildLoopingListDelegate(
              children: List.generate(5, (index) {
                return Stack(
                        fit: StackFit.loose,
                        alignment: Alignment.center,
                        children: [
                          Image.asset("images/p${index + 1}.jpeg"),
                          Text(
                            "$index",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ],
                      );
                // return Container(
                //   color: Colors.blue,
                //   alignment: Alignment.center,
                //   child: Stack(
                //     fit: StackFit.loose,
                //     alignment: Alignment.center,
                //     children: [
                //       Image.asset("images/p${index + 1}.jpeg"),
                //       Text(
                //         "$index",
                //         style: TextStyle(color: Colors.white, fontSize: 20),
                //       )
                //     ],
                //   ),
                // );
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
