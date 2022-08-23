
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/magic/refresh/magic_activity_indicator.dart';
import 'package:flutter_demo/magic/refresh/magic_refresh.dart';
import 'package:flutter_demo/page/common/common.dart';

class CustomRefreshDemo extends StatefulWidget {

  @override
  State<CustomRefreshDemo> createState() => _CustomRefreshDemoState();
}

class _CustomRefreshDemoState extends State<CustomRefreshDemo> {

  GlobalKey<MagicSliverRefreshControlState> key = GlobalKey<MagicSliverRefreshControlState>();


  @override
  Widget build(BuildContext context) {
    return Listener(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          MagicSliverRefreshControl(
            key: key,
            builder: buildRefreshIndicator,
            onRefresh: () async {
              print("<> SliverRefreshControl onRefresh start");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:  Text('is onRefresh!'),
                  duration:  Duration(milliseconds: 1500),
                  padding:  EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 10.0// Inner padding for SnackBar content.
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              );
              await Future.delayed(Duration(seconds: 2),(){


              });
              print("<> SliverRefreshControl onRefresh end");
            },
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (content, index) {
                return Common.getWidget(index);
              },
              childCount: 100,
            ),
          )
        ],
      ),
      onPointerUp: (event){
        if(key?.currentState?.isCanRefreshAction() ?? false){
          key?.currentState?.canRefresh = true;
        }else{
          key?.currentState?.canRefresh = false;
        }
      },
    );
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

  Widget _buildIndicatorForRefreshState(RefreshIndicatorMode refreshState, double radius, double percentageComplete) {
    print("<> _buildIndicatorForRefreshState $refreshState  $radius $percentageComplete");
    switch (refreshState) {
      case RefreshIndicatorMode.drag:
        const Curve opacityCurve = Interval(0.0, 0.35, curve: Curves.easeInOut);
        return Opacity(
          opacity: opacityCurve.transform(percentageComplete),
          child: MagicActivityIndicator.partiallyRevealed(radius: radius, progress: percentageComplete),
        );
      case RefreshIndicatorMode.armed:
      case RefreshIndicatorMode.refresh:
      // Once we're armed or performing the refresh, we just show the normal spinner.
        return MagicActivityIndicator(radius: radius);
      case RefreshIndicatorMode.done:
      // When the user lets go, the standard transition is to shrink the spinner.
        return MagicActivityIndicator(radius: radius * percentageComplete);
      case RefreshIndicatorMode.inactive:
      // Anything else doesn't show anything.
        return Container();
    }
  }
}



