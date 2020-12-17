import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

class DiySliverCustomer extends SingleChildRenderObjectWidget {


  @override
  _DiySliverCustomer createRenderObject(BuildContext context) {
    return _DiySliverCustomer();
  }

  DiySliverCustomer({
    Key key,
    Widget sliver,
  }) :super(key: key, child: sliver);
}

class _DiySliverCustomer extends RenderSliver
    with RenderObjectWithChildMixin<RenderSliver> {


  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry();
      return;
    }
    final SliverConstraints constraints = this.constraints;
    child.layout(
        constraints.asBoxConstraints(
          minExtent: 200,
          maxExtent: 1000,
          crossAxisExtent: 200,
        ),
        parentUsesSize: true);

    geometry = SliverGeometry(
      paintExtent: 200,
      cacheExtent: 200,
      hitTestExtent: 200,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    context.canvas.drawColor(Color(0xFF000000), BlendMode.color);
    context.canvas
        .drawCircle(Offset(100, 100), 10, Paint()..color = Color(0xFFFFFFFF));
    context.paintChild(child, offset);
  }

}



class DIYSliverPadding extends SingleChildRenderObjectWidget {
  const DIYSliverPadding({
    Key key,
    @required this.padding,
    Widget sliver,
  }) : assert(padding != null),
        super(key: key, child: sliver);

  final EdgeInsetsGeometry padding;

  @override
  DIYRenderSliverPadding createRenderObject(BuildContext context) {
    return DIYRenderSliverPadding(
      padding: padding,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, DIYRenderSliverPadding renderObject) {
    renderObject
      ..padding = padding
      ..textDirection = Directionality.of(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
  }
}


abstract class DIYRenderSliverEdgeInsetsPadding extends RenderSliver with RenderObjectWithChildMixin<RenderSliver> {
  EdgeInsets get resolvedPadding;

  double get beforePadding {
    assert(constraints != null);
    assert(constraints.axisDirection != null);
    assert(constraints.growthDirection != null);
    assert(resolvedPadding != null);
    switch (applyGrowthDirectionToAxisDirection(constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
        return resolvedPadding.bottom;
      case AxisDirection.right:
        return resolvedPadding.left;
      case AxisDirection.down:
        return resolvedPadding.top;
      case AxisDirection.left:
        return resolvedPadding.right;
    }
    return null;
  }

  double get afterPadding {
    assert(constraints != null);
    assert(constraints.axisDirection != null);
    assert(constraints.growthDirection != null);
    assert(resolvedPadding != null);
    switch (applyGrowthDirectionToAxisDirection(constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
        return resolvedPadding.top;
      case AxisDirection.right:
        return resolvedPadding.right;
      case AxisDirection.down:
        return resolvedPadding.bottom;
      case AxisDirection.left:
        return resolvedPadding.left;
    }
    return null;
  }

  double get mainAxisPadding {
    assert(constraints != null);
    assert(constraints.axis != null);
    assert(resolvedPadding != null);
    return resolvedPadding.along(constraints.axis);
  }

  double get crossAxisPadding {
    assert(constraints != null);
    assert(constraints.axis != null);
    assert(resolvedPadding != null);
    switch (constraints.axis) {
      case Axis.horizontal:
        return resolvedPadding.vertical;
      case Axis.vertical:
        return resolvedPadding.horizontal;
    }
    return null;
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverPhysicalParentData)
      child.parentData = SliverPhysicalParentData();
  }

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;
    assert(resolvedPadding != null);
    final double beforePadding = this.beforePadding;
    final double afterPadding = this.afterPadding;
    final double mainAxisPadding = this.mainAxisPadding;
    final double crossAxisPadding = this.crossAxisPadding;
    if (child == null) {
      geometry = SliverGeometry(
        scrollExtent: mainAxisPadding,
        paintExtent: math.min(mainAxisPadding, constraints.remainingPaintExtent),
        maxPaintExtent: mainAxisPadding,
      );
      return;
    }
    child.layout(
      constraints.copyWith(
        scrollOffset: math.max(0.0, constraints.scrollOffset - beforePadding),
        cacheOrigin: math.min(0.0, constraints.cacheOrigin + beforePadding),
        overlap: 0.0,
        remainingPaintExtent: constraints.remainingPaintExtent - calculatePaintOffset(constraints, from: 0.0, to: beforePadding),
        remainingCacheExtent: constraints.remainingCacheExtent - calculateCacheOffset(constraints, from: 0.0, to: beforePadding),
        crossAxisExtent: math.max(0.0, constraints.crossAxisExtent - crossAxisPadding),
        precedingScrollExtent: beforePadding + constraints.precedingScrollExtent,
      ),
      parentUsesSize: true,
    );
    final SliverGeometry childLayoutGeometry = child.geometry;
    if (childLayoutGeometry.scrollOffsetCorrection != null) {
      geometry = SliverGeometry(
        scrollOffsetCorrection: childLayoutGeometry.scrollOffsetCorrection,
      );
      return;
    }
    final double beforePaddingPaintExtent = calculatePaintOffset(
      constraints,
      from: 0.0,
      to: beforePadding,
    );
    final double afterPaddingPaintExtent = calculatePaintOffset(
      constraints,
      from: beforePadding + childLayoutGeometry.scrollExtent,
      to: mainAxisPadding + childLayoutGeometry.scrollExtent,
    );
    final double mainAxisPaddingPaintExtent = beforePaddingPaintExtent + afterPaddingPaintExtent;
    final double beforePaddingCacheExtent = calculateCacheOffset(
      constraints,
      from: 0.0,
      to: beforePadding,
    );
    final double afterPaddingCacheExtent = calculateCacheOffset(
      constraints,
      from: beforePadding + childLayoutGeometry.scrollExtent,
      to: mainAxisPadding + childLayoutGeometry.scrollExtent,
    );
    final double mainAxisPaddingCacheExtent = afterPaddingCacheExtent + beforePaddingCacheExtent;
    final double paintExtent = math.min(
      beforePaddingPaintExtent + math.max(childLayoutGeometry.paintExtent, childLayoutGeometry.layoutExtent + afterPaddingPaintExtent),
      constraints.remainingPaintExtent,
    );
    geometry = SliverGeometry(
      scrollExtent: mainAxisPadding + childLayoutGeometry.scrollExtent,
      paintExtent: paintExtent,
      layoutExtent: math.min(mainAxisPaddingPaintExtent + childLayoutGeometry.layoutExtent, paintExtent),
      cacheExtent: math.min(mainAxisPaddingCacheExtent + childLayoutGeometry.cacheExtent, constraints.remainingCacheExtent),
      maxPaintExtent: mainAxisPadding + childLayoutGeometry.maxPaintExtent,
      hitTestExtent: math.max(
        mainAxisPaddingPaintExtent + childLayoutGeometry.paintExtent,
        beforePaddingPaintExtent + childLayoutGeometry.hitTestExtent,
      ),
      hasVisualOverflow: childLayoutGeometry.hasVisualOverflow,
    );

    final SliverPhysicalParentData childParentData = child.parentData as SliverPhysicalParentData;
    assert(constraints.axisDirection != null);
    assert(constraints.growthDirection != null);
    switch (applyGrowthDirectionToAxisDirection(constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
        childParentData.paintOffset = Offset(resolvedPadding.left, calculatePaintOffset(constraints, from: resolvedPadding.bottom + childLayoutGeometry.scrollExtent, to: resolvedPadding.bottom + childLayoutGeometry.scrollExtent + resolvedPadding.top));
        break;
      case AxisDirection.right:
        childParentData.paintOffset = Offset(calculatePaintOffset(constraints, from: 0.0, to: resolvedPadding.left), resolvedPadding.top);
        break;
      case AxisDirection.down:
        childParentData.paintOffset = Offset(resolvedPadding.left, calculatePaintOffset(constraints, from: 0.0, to: resolvedPadding.top));
        break;
      case AxisDirection.left:
        childParentData.paintOffset = Offset(calculatePaintOffset(constraints, from: resolvedPadding.right + childLayoutGeometry.scrollExtent, to: resolvedPadding.right + childLayoutGeometry.scrollExtent + resolvedPadding.left), resolvedPadding.top);
        break;
    }
    assert(childParentData.paintOffset != null);
    assert(beforePadding == this.beforePadding);
    assert(afterPadding == this.afterPadding);
    assert(mainAxisPadding == this.mainAxisPadding);
    assert(crossAxisPadding == this.crossAxisPadding);
  }

  @override
  bool hitTestChildren(SliverHitTestResult result, { @required double mainAxisPosition, @required double crossAxisPosition }) {
    if (child != null && child.geometry.hitTestExtent > 0.0) {
      final SliverPhysicalParentData childParentData = child.parentData as SliverPhysicalParentData;
      result.addWithAxisOffset(
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition,
        mainAxisOffset: childMainAxisPosition(child),
        crossAxisOffset: childCrossAxisPosition(child),
        paintOffset: childParentData.paintOffset,
        hitTest: child.hitTest,
      );
    }
    return false;
  }

  @override
  double childMainAxisPosition(RenderSliver child) {
    assert(child != null);
    assert(child == this.child);
    return calculatePaintOffset(constraints, from: 0.0, to: beforePadding);
  }

  @override
  double childCrossAxisPosition(RenderSliver child) {
    assert(child != null);
    assert(child == this.child);
    assert(constraints != null);
    assert(constraints.axisDirection != null);
    assert(constraints.growthDirection != null);
    assert(resolvedPadding != null);
    switch (applyGrowthDirectionToAxisDirection(constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
      case AxisDirection.down:
        return resolvedPadding.left;
      case AxisDirection.left:
      case AxisDirection.right:
        return resolvedPadding.top;
    }
    return null;
  }

  @override
  double childScrollOffset(RenderObject child) {
    assert(child.parent == this);
    return beforePadding;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child != null);
    assert(child == this.child);
    final SliverPhysicalParentData childParentData = child.parentData as SliverPhysicalParentData;
    childParentData.applyPaintTransform(transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && child.geometry.visible) {
      final SliverPhysicalParentData childParentData = child.parentData as SliverPhysicalParentData;
      context.paintChild(child, offset + childParentData.paintOffset);
    }
  }

  @override
  void debugPaint(PaintingContext context, Offset offset) {
    super.debugPaint(context, offset);
    assert(() {
      if (debugPaintSizeEnabled) {
        final Size parentSize = getAbsoluteSize();
        final Rect outerRect = offset & parentSize;
        Size childSize;
        Rect innerRect;
        if (child != null) {
          childSize = child.getAbsoluteSize();
          final SliverPhysicalParentData childParentData = child.parentData as SliverPhysicalParentData;
          innerRect = (offset + childParentData.paintOffset) & childSize;
          assert(innerRect.top >= outerRect.top);
          assert(innerRect.left >= outerRect.left);
          assert(innerRect.right <= outerRect.right);
          assert(innerRect.bottom <= outerRect.bottom);
        }
        debugPaintPadding(context.canvas, outerRect, innerRect);
      }
      return true;
    }());
  }
}

class DIYRenderSliverPadding extends DIYRenderSliverEdgeInsetsPadding {
  DIYRenderSliverPadding({
    @required EdgeInsetsGeometry padding,
    TextDirection textDirection,
    RenderSliver child,
  }) : assert(padding != null),
        assert(padding.isNonNegative),
        _padding = padding,
        _textDirection = textDirection {
    this.child = child;
  }

  @override
  EdgeInsets get resolvedPadding => _resolvedPadding;
  EdgeInsets _resolvedPadding;

  void _resolve() {
    if (resolvedPadding != null)
      return;
    _resolvedPadding = padding.resolve(textDirection);
    assert(resolvedPadding.isNonNegative);
  }

  void _markNeedsResolution() {
    _resolvedPadding = null;
    markNeedsLayout();
  }

  EdgeInsetsGeometry get padding => _padding;
  EdgeInsetsGeometry _padding;
  set padding(EdgeInsetsGeometry value) {
    assert(value != null);
    assert(padding.isNonNegative);
    if (_padding == value)
      return;
    _padding = value;
    _markNeedsResolution();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value)
      return;
    _textDirection = value;
    _markNeedsResolution();
  }

  @override
  void performLayout() {
    _resolve();
    super.performLayout();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection, defaultValue: null));
  }
}


class DIYSliverToBoxAdapter extends SingleChildRenderObjectWidget {
  const DIYSliverToBoxAdapter({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  DIYRenderSliverToBoxAdapter createRenderObject(BuildContext context) => DIYRenderSliverToBoxAdapter();
}


class DIYRenderSliverToBoxAdapter extends RenderSliverSingleBoxAdapter {
  DIYRenderSliverToBoxAdapter({
    RenderBox child,
  }) : super(child: child);

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    child.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child.size.width;
        break;
      case Axis.vertical:
        childExtent = child.size.height;
        break;
    }
    assert(childExtent != null);
    final double paintedChildSize = calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent = calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
    );
    setChildParentData(child, constraints, geometry);
  }
}
