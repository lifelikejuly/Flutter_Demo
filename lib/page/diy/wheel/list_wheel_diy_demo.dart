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

    Size screenSize = MediaQuery.of(context).size;
    double cellWidth = screenSize.width / 3;
    double cellHeight = 220 / cellWidth *  293;


    cellWidth = 220 / 375 * screenSize.width;
    cellHeight = cellWidth / (220 / 293);

    print("<> build MediaQuery.of(context).size  $screenSize  cellWidth $cellWidth  cellHeight $cellHeight");

    return Stack(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: cellHeight * 2.5,
          color: Colors.yellow,
          child: DIYListWheelScrollView.useDelegate(
            renderChildrenOutsideViewport: true,
            controller: scrollController,
            physics: DIYFixedExtentScrollPhysics(),
            squeeze: 0.5,
            itemExtent: cellWidth,
            childSize: Size(cellWidth,cellHeight),
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
                          Container(
                            width: cellWidth,
                            color: Colors.red.withOpacity(0.5),
                          ),
                          Image.asset("images/p${index + 1}.jpeg",width: cellWidth ,height:220 / cellWidth *  293,fit: BoxFit.fitHeight,),
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
