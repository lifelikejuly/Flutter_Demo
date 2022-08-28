import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/loadmore/magic_loadmore.dart';
import 'package:flutter_demo/page/common/common.dart';

import 'custom_simple_loadmore_demo.dart';

class CustomLoadMoreDemo extends StatefulWidget {

  @override
  State<CustomLoadMoreDemo> createState() => _CustomLoadMoreDemoState();
}

class _CustomLoadMoreDemoState extends State<CustomLoadMoreDemo> {
  @override
  Widget build(BuildContext context) {
    // return CustomScrollView(
    //     physics: BouncingScrollPhysics(),
    //     slivers: <Widget>[
    //       SliverList(
    //         delegate: SliverChildBuilderDelegate(
    //               (content, index) {
    //             return Common.getWidget(index);
    //           },
    //           childCount: 15,
    //         ),
    //       ),
    //       MagicSliverLoadMoreControl(
    //         builder: buildRefreshIndicator,
    //         onRefresh: () async {
    //           print("<> SliverRefreshControl onRefresh start");
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             SnackBar(
    //               content:  Text('is onRefresh!'),
    //               duration:  Duration(milliseconds: 1500),
    //               padding:  EdgeInsets.symmetric(
    //                   horizontal: 8.0,
    //                   vertical: 10.0// Inner padding for SnackBar content.
    //               ),
    //               behavior: SnackBarBehavior.floating,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10.0),
    //               ),
    //             ),
    //           );
    //           await Future.delayed(Duration(seconds: 2),(){
    //
    //
    //           });
    //           print("<> SliverRefreshControl onRefresh end");
    //         },
    //       ),
    //     ],
    //   );
    return CustomSimpleLoadMoreDemo();
  }

  Widget buildRefreshIndicator(
      BuildContext context,
      RefreshIndicatorMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      ) {
    final double percentageComplete = (pulledExtent / refreshTriggerPullDistance).clamp(0.0, 1.0);
    final double percentageComplete2 = (pulledExtent / refreshIndicatorExtent).clamp(0.0, 1.0);
    // print("<> buildRefreshIndicator refreshState $refreshState percentageComplete $percentageComplete percentageComplete2 $percentageComplete2");

    // print("<> buildRefreshIndicator refreshState $refreshState ");

    return Container(
      color: Colors.deepOrange,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            // top: -refreshIndicatorExtent + percentageComplete2 * refreshIndicatorExtent,
            top: -refreshIndicatorExtent + pulledExtent,
            left: 0.0,
            right: 0.0,
            // child: _buildIndicatorForRefreshState(refreshState, 14, percentageComplete),
            // child : MagicActivityIndicator(radius: 14,),
            child: Container(
              child: Text("我是下拉呀~~~~",style: TextStyle(color: Colors.white,fontSize: 20,),textAlign: TextAlign.center,),
            ),
          ),
        ],
      ),
    );
  }
}
