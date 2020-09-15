import 'package:flutter/material.dart';

class PagingScrollPhysics extends ScrollPhysics {
  final double itemDimension; // ListView children item 固定宽度
  final double leadingSpacing; // 选中 item 离左边缘留白
  final double maxSize; // 最大可滑动区域

  PagingScrollPhysics(
      {this.maxSize,
        this.leadingSpacing,
        this.itemDimension,
        ScrollPhysics parent})
      : super(parent: parent);

  @override
  PagingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return PagingScrollPhysics(
        maxSize: maxSize,
        itemDimension: itemDimension,
        leadingSpacing: leadingSpacing,
        parent: buildParent(ancestor));
  }

  double _getPage(ScrollPosition position, double leading) {
    return ((position?.pixels ?? 0) + leading) / itemDimension * 1.0;
  }

  double _getPixels(double page, double leading) {
    return (page * itemDimension) - leading;
  }

  double _getTargetPixels(
      ScrollPosition position,
      Tolerance tolerance,
      double velocity,
      double leading,
      ) {
    double page = _getPage(position, leading);

    if (position.pixels < 0) {
      return 0;
    }

    if (position.pixels >= maxSize) {
      return maxSize;
    }

    if (position.pixels > 0) {
      if (velocity < -tolerance.velocity) {
        page -= 0.5;
      } else if (velocity > tolerance.velocity) {
        page += 0.5;
      }
      return _getPixels(page.roundToDouble(), leading);
    }
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.

    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent))
      return super.createBallisticSimulation(position, velocity);

    final Tolerance tolerance = this.tolerance;

    final double target =
    _getTargetPixels(position, tolerance, velocity, leadingSpacing);
    if (target != position.pixels)
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
