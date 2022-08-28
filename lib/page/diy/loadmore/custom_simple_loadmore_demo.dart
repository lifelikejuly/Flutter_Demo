import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/diy_scroll_physics.dart';
import 'package:flutter_demo/page/common/common.dart';
import 'dart:math' as math;

class CustomSimpleLoadMoreDemo extends StatefulWidget {
  @override
  State<CustomSimpleLoadMoreDemo> createState() =>
      _CustomSimpleLoadMoreDemoState();
}

class _CustomSimpleLoadMoreDemoState extends State<CustomSimpleLoadMoreDemo> {
  int length = 10;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return NotificationListener(
      onNotification: (scrollNotification) {
        // if(scrollNotification is OverscrollIndicatorNotification){
        //   return false;
        // }
        if ((scrollNotification.metrics.pixels >=
                scrollNotification.metrics.maxScrollExtent - size.height) &&
            (scrollNotification.depth == 0)) {
          if (length >= 30) {
            return false;
          }
          if (!isLoading) {
            isLoading = true;
            Future.delayed(Duration(seconds: 2), () {
              isLoading = false;
              length += 10;
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('下拉加载更多了！！！'),
                duration: Duration(milliseconds: 700),
              ));
              setState(() {});
            });
          }
        }
        return false;
      },
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (content, index) {
                return Common.getWidget(index);
              },
              childCount: length,
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                length < 30 ? "加载更多...." : "没有更多",
                style: TextStyle(fontSize: 25),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomBouncingScrollPhysics extends ScrollPhysics {
  const CustomBouncingScrollPhysics({ ScrollPhysics parent }) : super(parent: parent);

  @override
  CustomBouncingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  double frictionFactor(double overscrollFraction) => 0.52 * math.pow(1 - overscrollFraction, 2);



  /// 阻尼参数计算
  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    assert(offset != 0.0);
    assert(position.minScrollExtent <= position.maxScrollExtent);

    if (!position.outOfRange)
      return offset;

    final double overscrollPastStart = math.max(position.minScrollExtent - position.pixels, 0.0);
    final double overscrollPastEnd = math.max(position.pixels - position.maxScrollExtent, 0.0);
    final double overscrollPast = math.max(overscrollPastStart, overscrollPastEnd);
    final bool easing = (overscrollPastStart > 0.0 && offset < 0.0)
        || (overscrollPastEnd > 0.0 && offset > 0.0);
    final double friction = easing
    // Apply less resistance when easing the overscroll vs tensioning.
        ? frictionFactor((overscrollPast - offset.abs()) / position.viewportDimension)
        : frictionFactor(overscrollPast / position.viewportDimension);
    final double direction = offset.sign;

    return direction * _applyFriction(overscrollPast, offset.abs(), friction);
  }

  static double _applyFriction(double extentOutside, double absDelta, double gamma) {
    assert(absDelta > 0);
    double total = 0.0;
    if (extentOutside > 0) {
      final double deltaToLimit = extentOutside / gamma;
      if (absDelta < deltaToLimit)
        return absDelta * gamma;
      total += extentOutside;
      absDelta -= deltaToLimit;
    }
    return total + absDelta;
  }


  /// 边界条件 复用ClampingScrollPhysics的方法 保留列表在底部的边界判断条件
  @override
  double applyBoundaryConditions(ScrollMetrics position, double value){
    if (position.maxScrollExtent <= position.pixels && position.pixels < value) // overscroll
      return value - position.pixels;
    if (position.pixels < position.maxScrollExtent && position.maxScrollExtent < value) // hit bottom edge
      return value - position.maxScrollExtent;
    return 0.0;
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity * 0.91, // TODO(abarth): We should move this constant closer to the drag end.
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }

  @override
  double get minFlingVelocity => kMinFlingVelocity * 2.0;

  @override
  double carriedMomentum(double existingVelocity) {
    return existingVelocity.sign *
        math.min(0.000816 * math.pow(existingVelocity.abs(), 1.967).toDouble(), 40000.0);
  }

  @override
  double get dragStartDistanceMotionThreshold => 3.5;
}