import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';
import 'package:flutter_demo/page/diy/wheel/diy_list_wheel_scroll_view2.dart';
import 'package:flutter_demo/page/widget/common_widget_demo.dart';

class ListScrollChangeDemo extends StatefulWidget {
  @override
  State<ListScrollChangeDemo> createState() => _ListScrollChangeDemoState();
}

class _ListScrollChangeDemoState extends State<ListScrollChangeDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          height: 100,
          child: ListView.builder(
            itemExtent: 70,
            physics: ListPageScrollPhysics(),
            scrollDirection: Axis.horizontal,
            // controller: FixedExtentScrollController(),
            // physics: FixedExtentScrollPhysics(),
            itemBuilder: (context, index) {
              return Common.getWidget(index);
            },
          ),
        ),
        Container(
          height: 200,
          child: DIY2ListWheelScrollView.useDelegate(
            renderChildrenOutsideViewport: false,
            // offAxisFraction: -0.5,
            itemExtent: 50,
            physics: DIY2FixedExtentScrollPhysics(),
            controller: DIY2FixedExtentScrollController(),
            onSelectedItemChanged: (index) {
              print("ListWheelScrollView onSelectedItemChanged $index");
            },
            childDelegate: DIY2ListWheelChildBuilderDelegate( //ListWheelChildLoopingListDelegate
              builder: (context, index) {
                return Common.getWidget(index);
              },
            ),
          ),
        ),
        Container(
          height: 200,
          child: PageView.builder(
            itemBuilder: (context, index) {
              return Common.getWidget(index);
            },
          ),
        )
      ],
    ));
  }
}

// ListView阻尼滑动
class ListPageScrollPhysics extends ScrollPhysics {
  /// Creates physics for a [PageView].
  const ListPageScrollPhysics({ ScrollPhysics parent }) : super(parent: parent);

  @override
  ListPageScrollPhysics applyTo(ScrollPhysics ancestor) {
    return ListPageScrollPhysics(parent: buildParent(ancestor));
  }

  double _getPage(ScrollMetrics position) {
    print("<> _getPage position.pixels ${position.pixels}");
    return position.pixels / 50;
  }

  double _getPixels(ScrollMetrics position, double page) {
    return page * 50;
  }

  double _getTargetPixels(ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity)
      page -= 0.5;
    else if (velocity > tolerance.velocity)
      page += 0.5;
    return _getPixels(position, page.roundToDouble());
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent))
      return super.createBallisticSimulation(position, velocity);
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels)
      return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
