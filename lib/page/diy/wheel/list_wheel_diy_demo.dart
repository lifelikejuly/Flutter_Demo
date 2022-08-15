import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';

import 'diy_list_wheel_scroll_view.dart';

class ListWheelDiyDemo extends StatefulWidget {
  @override
  State<ListWheelDiyDemo> createState() => _ListWheelDiyDemoState();


}


//  Image.asset("images/p${index + 1}.jpeg",width: cellWidth ,height:220 / cellWidth *  293,fit: BoxFit.fitHeight,),

class _ListWheelDiyDemoState extends State<ListWheelDiyDemo> {
  DIYFixedExtentScrollController scrollController;


  @override
  void initState() {
    super.initState();
    scrollController = DIYFixedExtentScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final double cellWidth = 300 / 375 * MediaQuery.of(context).size.width;
    final double cellHeight = cellWidth / (300 / 293);

    // height: (MediaQuery.of(context).size.width / (375 / 490)),

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: (MediaQuery.of(context).size.width / (375 / 490)),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 120,
                  child: Container(
                    height: (MediaQuery.of(context).size.width / (375 / 490)) *
                        (293 / 490),
                    color: Colors.red.withOpacity(0.2),
                    child: DIYListWheelScrollView.useDelegate(
                      controller: scrollController,
                      renderChildrenOutsideViewport: true,
                      physics: DIYFixedExtentScrollPhysics(),
                      squeeze: 0.5,
                      itemExtent: cellWidth,
                      childSize: Size(cellWidth, cellHeight),
                      onSelectedItemChanged: (index) {
                        print(
                            "ListWheelScrollView onSelectedItemChanged $index");
                      },
                      clipBehavior: Clip.none,
                      childDelegate: DIYListWheelChildLoopingListDelegate(
                        children: List.generate(5, (index) {
                          return Container(
                            // color: Colors.blue,
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Image.asset("images/p${index + 1}.jpeg",width: cellWidth ,height:220 / cellWidth *  293,fit: BoxFit.fitHeight,),
                                Image.asset("images/res/wa${index + 1}.png",width: cellWidth ,height:220 / cellWidth *  293,fit: BoxFit.fitHeight,),
                                Text(
                                  "$index",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
