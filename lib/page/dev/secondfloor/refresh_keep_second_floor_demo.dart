import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';
import 'package:flutter_demo/page/dev/secondfloor/floor_refresh.dart';

class RefreshKeepDemo extends StatefulWidget {
  @override
  _RefreshKeepDemoState createState() => _RefreshKeepDemoState();
}

class _RefreshKeepDemoState extends State<RefreshKeepDemo> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Listener(
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                FloorSliverRefreshControl(
                  builder: buildSimpleRefreshIndicator,
                  onRefresh: () async {
                    print(
                        "<> CupertinoSliverRefreshControl  -------> onRefresh()");
                    await Future.delayed(Duration(seconds: 5));
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
            onPointerDown: (PointerDownEvent event){
              print("<> Listener onPointerDown");
            },
            onPointerCancel: (PointerCancelEvent event){
              print("<> Listener onPointerCancel");
            },
            onPointerUp: (PointerUpEvent event){
              print("<> Listener onPointerUp");
            },
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              print("<> RefreshIndicator -------> onRefresh");
              await Future.delayed(Duration(seconds: 2));
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Common.getWidget(index);
              },
              itemCount: 100,
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildSimpleRefreshIndicator(
    BuildContext context,
    FloorRefreshIndicatorMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
  ) {
    const Curve opacityCurve = Interval(0.4, 0.8, curve: Curves.easeInOut);

    Widget child = Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: refreshState == FloorRefreshIndicatorMode.drag
            ? Opacity(
                opacity: opacityCurve.transform(
                    min(pulledExtent / refreshTriggerPullDistance, 1.0)),
                child: Icon(
                  CupertinoIcons.down_arrow,
                  color: CupertinoDynamicColor.resolve(
                      CupertinoColors.inactiveGray, context),
                  size: 36.0,
                ),
              )
            : Opacity(
                opacity: opacityCurve
                    .transform(min(pulledExtent / refreshIndicatorExtent, 1.0)),
                child: const CupertinoActivityIndicator(radius: 14.0),
              ),
      ),
    );
    child = Container(
      child: child,
      color: Colors.tealAccent,
    );
    return child;
  }
}
