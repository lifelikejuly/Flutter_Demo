import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'dart:math' as math;
//https://github.com/mrdaios/flutter_group_sliver/blob/master/example/lib/demo_page.dart

class SliverContainer extends RenderObjectWidget {
  const SliverContainer({
    Key key,
    @required this.sliver,
    @required this.container,
  })  : super(key: key);

  final Widget sliver;
  final Container container;
  BoxDecoration get decoration => (container.decoration as BoxDecoration);



  @override
  _RenderSliverContainer createRenderObject(BuildContext context) {
    return _RenderSliverContainer(
      margin: container.padding,
      borderRadius: decoration.borderRadius,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderSliverContainer renderObject) {
    renderObject
      ..margin =  container.padding
      ..borderRadius = decoration.borderRadius;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', container.padding));
  }

  @override
  _SliverContainerElement createElement() {
    return _SliverContainerElement(this);
  }
}

class _SliverContainerElement extends RenderObjectElement {
  _SliverContainerElement(SliverContainer widget) : super(widget);

  Element _decoration;
  Element _sliver;

  @override
  SliverContainer get widget => super.widget;

  @override
  void visitChildren(visitor) {
    super.visitChildren(visitor);
    if (_decoration != null) visitor(_decoration);
    if (_sliver != null) visitor(_sliver);
  }

  @override
  void forgetChild(Element child) {
    super.forgetChild(child);
    if (child == _decoration) _decoration = null;
    if (child == _sliver) _sliver = null;
  }

  @override
  void mount(Element parent, newSlot) {
    super.mount(parent, newSlot);
    _decoration = updateChild(_decoration, widget.container, 0);
    _sliver = updateChild(_sliver, widget.sliver, 1);
  }

  @override
  void update(RenderObjectWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _decoration = updateChild(_decoration, widget.container, 0);
    _sliver = updateChild(_sliver, widget.sliver, 1);
  }

  @override
  void insertChildRenderObject(RenderObject child, int slot) {
    final _RenderSliverContainer renderObject = this.renderObject;
    if (slot == 0) renderObject.decoration = child;
    if (slot == 1) renderObject.child = child;
    assert(renderObject == this.renderObject);
  }

  @override
  void moveChildRenderObject(RenderObject child, slot) {}

  @override
  void removeChildRenderObject(RenderObject child) {
    final _RenderSliverContainer renderObject = this.renderObject;
    if (renderObject.decoration == child) renderObject.decoration = null;
    if (renderObject.child == child) renderObject.child = null;
    assert(renderObject == this.renderObject);
  }
}

class _RenderSliverContainer extends RenderSliver
    with RenderObjectWithChildMixin<RenderSliver> {
  _RenderSliverContainer(
      {EdgeInsetsGeometry margin,
      BorderRadius borderRadius,
      RenderBox decoration,
      RenderSliver child}) {
    this.margin = margin;
    this.borderRadius = borderRadius;
    this.decoration = decoration;
    this.child = child;
  }

  RRect _clipRRect;

  EdgeInsetsGeometry get margin => _margin;
  EdgeInsetsGeometry _margin;

  set margin(EdgeInsetsGeometry value) {
    assert(value != null);
    assert(value.isNonNegative);
    if (_margin == value) return;
    _margin = value;
    markNeedsLayout();
  }

  BorderRadiusGeometry get borderRadius => _borderRadius;
  BorderRadiusGeometry _borderRadius;

  set borderRadius(BorderRadiusGeometry value) {
    if (value == _borderRadius) return;
    _borderRadius = value;
    markNeedsPaint();
  }

  RenderBox get decoration => _decoration;
  RenderBox _decoration;

  set decoration(RenderBox value) {
    if (_decoration != null) dropChild(_decoration);
    _decoration = value;
    if (_decoration != null) adoptChild(_decoration);
  }

  RenderSliver get child => _child;
  RenderSliver _child;

  set child(RenderSliver value) {
    if (_child != null) dropChild(_child);
    _child = value;
    if (_child != null) adoptChild(_child);
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverPhysicalParentData)
      child.parentData = new SliverPhysicalParentData();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (_decoration != null) _decoration.attach(owner);
    if (_child != null) _child.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    if (_decoration != null) _decoration.detach();
    if (_child != null) _child.detach();
  }

  @override
  void redepthChildren() {
    if (_decoration != null) redepthChild(_decoration);
    if (_child != null) redepthChild(_child);
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (_decoration != null) visitor(_decoration);
    if (_child != null) visitor(_child);
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    List<DiagnosticsNode> result = <DiagnosticsNode>[];
    if (decoration != null) {
      result.add(decoration.toDiagnosticsNode(name: 'decoration'));
    }
    if (child != null) {
      result.add(child.toDiagnosticsNode(name: 'child'));
    }
    return result;
  }

  @override
  bool hitTestChildren(HitTestResult result,
      {double mainAxisPosition, double crossAxisPosition}) {
    assert(geometry.hitTestExtent > 0.0);
    return child.hitTest(result,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition);
  }

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry();
      return;
    }
    // child not null
    AxisDirection axisDirection = applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection);
    // layout sliver
    child.layout(constraints, parentUsesSize: true);
    final SliverGeometry childLayoutGeometry = child.geometry;
    geometry = childLayoutGeometry;

    // layout decoration with child size + margin
    EdgeInsets margin = this.margin.resolve(TextDirection.ltr);
    if (decoration != null) {
      decoration.layout(
          constraints.asBoxConstraints(
              maxExtent: childLayoutGeometry.maxPaintExtent + margin.horizontal,
              crossAxisExtent: constraints.crossAxisExtent + margin.vertical),
          parentUsesSize: true);
    }
    // compute decoration offset
    final SliverPhysicalParentData headerParentData = decoration.parentData;
    double headerPosition = -constraints.scrollOffset;
    switch (axisDirection) {
      case AxisDirection.up:
        headerParentData.paintOffset =
            new Offset(0.0, geometry.paintExtent - 0 - 0);
        break;
      case AxisDirection.down:
        headerParentData.paintOffset =
            new Offset(-margin.left, headerPosition - margin.top);
        break;
      case AxisDirection.left:
        headerParentData.paintOffset =
            new Offset(geometry.paintExtent - 0 - 0, 0.0);
        break;
      case AxisDirection.right:
        headerParentData.paintOffset = new Offset(0, 0.0);
        break;
    }
    //compute child clip
    if (this.borderRadius != null) {
      BorderRadius borderRadius = this.borderRadius.resolve(TextDirection.ltr);
      _clipRRect = borderRadius.toRRect(Rect.fromLTRB(
          0, 0, constraints.crossAxisExtent, geometry.maxPaintExtent));
      double offSetY = headerPosition;
      _clipRRect = _clipRRect.shift(Offset(0, offSetY));
    }
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child != null);
    final SliverPhysicalParentData childParentData = child.parentData;
    childParentData.applyPaintTransform(transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (geometry.visible) {
      // paint decoration
      if (decoration != null) {
        final SliverPhysicalParentData childParentData = decoration.parentData;
        context.paintChild(decoration, offset + childParentData.paintOffset);
      }
      // paint child
      if (child != null && child.geometry.visible) {
        final SliverPhysicalParentData childParentData = child.parentData;
        final PaintingContextCallback painter =
            (PaintingContext context, Offset offset) {
          context.paintChild(child, offset);
        };
        if (_clipRRect != null && _clipRRect != RRect.zero) {
          context.pushClipRRect(
            needsCompositing,
            offset + childParentData.paintOffset,
            _clipRRect.outerRect,
            _clipRRect,
            painter,
          );
        } else {
          painter(context, offset + childParentData.paintOffset);
        }
      }
    }
  }
}

class RenderSliverPadding extends RenderSliverEdgeInsetsPadding {
  RenderSliverPadding({
    @required EdgeInsetsGeometry padding,
    TextDirection textDirection,
    RenderSliver child,
  })  : assert(padding != null),
        assert(padding.isNonNegative),
        _padding = padding,
        _textDirection = textDirection {
    this.child = child;
  }

  @override
  EdgeInsets get resolvedPadding => _resolvedPadding;
  EdgeInsets _resolvedPadding;

  void _resolve() {
    if (resolvedPadding != null) return;
    _resolvedPadding = padding.resolve(textDirection);
    assert(resolvedPadding.isNonNegative);
  }

  void _markNeedsResolution() {
    _resolvedPadding = null;
    markNeedsLayout();
  }

  /// The amount to pad the child in each dimension.
  ///
  /// If this is set to an [EdgeInsetsDirectional] object, then [textDirection]
  /// must not be null.
  EdgeInsetsGeometry get padding => _padding;
  EdgeInsetsGeometry _padding;

  set padding(EdgeInsetsGeometry value) {
    assert(value != null);
    assert(padding.isNonNegative);
    if (_padding == value) return;
    _padding = value;
    _markNeedsResolution();
  }

  /// The text direction with which to resolve [padding].
  ///
  /// This may be changed to null, but only after the [padding] has been changed
  /// to a value that does not depend on the direction.
  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
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
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
  }
}

abstract class RenderSliverEdgeInsetsPadding extends RenderSliver
    with RenderObjectWithChildMixin<RenderSliver> {
  /// The amount to pad the child in each dimension.
  ///
  /// The offsets are specified in terms of visual edges, left, top, right, and
  /// bottom. These values are not affected by the [TextDirection].
  ///
  /// Must not be null or contain negative values when [performLayout] is called.
  EdgeInsets get resolvedPadding;

  /// The padding in the scroll direction on the side nearest the 0.0 scroll direction.
  ///
  /// Only valid after layout has started, since before layout the render object
  /// doesn't know what direction it will be laid out in.
  double get beforePadding {
    assert(constraints != null);
    assert(constraints.axisDirection != null);
    assert(constraints.growthDirection != null);
    assert(resolvedPadding != null);
    switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection)) {
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

  /// The padding in the scroll direction on the side furthest from the 0.0 scroll offset.
  ///
  /// Only valid after layout has started, since before layout the render object
  /// doesn't know what direction it will be laid out in.
  double get afterPadding {
    assert(constraints != null);
    assert(constraints.axisDirection != null);
    assert(constraints.growthDirection != null);
    assert(resolvedPadding != null);
    switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection)) {
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

  /// The total padding in the [SliverConstraints.axisDirection]. (In other
  /// words, for a vertical downwards-growing list, the sum of the padding on
  /// the top and bottom.)
  ///
  /// Only valid after layout has started, since before layout the render object
  /// doesn't know what direction it will be laid out in.
  double get mainAxisPadding {
    assert(constraints != null);
    assert(constraints.axis != null);
    assert(resolvedPadding != null);
    return resolvedPadding.along(constraints.axis);
  }

  /// The total padding in the cross-axis direction. (In other words, for a
  /// vertical downwards-growing list, the sum of the padding on the left and
  /// right.)
  ///
  /// Only valid after layout has started, since before layout the render object
  /// doesn't know what direction it will be laid out in.
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
        paintExtent:
            math.min(mainAxisPadding, constraints.remainingPaintExtent),
        maxPaintExtent: mainAxisPadding,
      );
      return;
    }
    child.layout(
      constraints.copyWith(
        scrollOffset: math.max(0.0, constraints.scrollOffset - beforePadding),
        cacheOrigin: math.min(0.0, constraints.cacheOrigin + beforePadding),
        overlap: 0.0,
        remainingPaintExtent: constraints.remainingPaintExtent -
            calculatePaintOffset(constraints, from: 0.0, to: beforePadding),
        remainingCacheExtent: constraints.remainingCacheExtent -
            calculateCacheOffset(constraints, from: 0.0, to: beforePadding),
        crossAxisExtent:
            math.max(0.0, constraints.crossAxisExtent - crossAxisPadding),
        precedingScrollExtent:
            beforePadding + constraints.precedingScrollExtent,
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
    final double mainAxisPaddingPaintExtent =
        beforePaddingPaintExtent + afterPaddingPaintExtent;
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
    final double mainAxisPaddingCacheExtent =
        afterPaddingCacheExtent + beforePaddingCacheExtent;
    final double paintExtent = math.min(
      beforePaddingPaintExtent +
          math.max(childLayoutGeometry.paintExtent,
              childLayoutGeometry.layoutExtent + afterPaddingPaintExtent),
      constraints.remainingPaintExtent,
    );
    geometry = SliverGeometry(
      scrollExtent: mainAxisPadding + childLayoutGeometry.scrollExtent,
      paintExtent: paintExtent,
      layoutExtent: math.min(
          mainAxisPaddingPaintExtent + childLayoutGeometry.layoutExtent,
          paintExtent),
      cacheExtent: math.min(
          mainAxisPaddingCacheExtent + childLayoutGeometry.cacheExtent,
          constraints.remainingCacheExtent),
      maxPaintExtent: mainAxisPadding + childLayoutGeometry.maxPaintExtent,
      hitTestExtent: math.max(
        mainAxisPaddingPaintExtent + childLayoutGeometry.paintExtent,
        beforePaddingPaintExtent + childLayoutGeometry.hitTestExtent,
      ),
      hasVisualOverflow: childLayoutGeometry.hasVisualOverflow,
    );

    final SliverPhysicalParentData childParentData =
        child.parentData as SliverPhysicalParentData;
    assert(constraints.axisDirection != null);
    assert(constraints.growthDirection != null);
    switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
        childParentData.paintOffset = Offset(
            resolvedPadding.left,
            calculatePaintOffset(constraints,
                from: resolvedPadding.bottom + childLayoutGeometry.scrollExtent,
                to: resolvedPadding.bottom +
                    childLayoutGeometry.scrollExtent +
                    resolvedPadding.top));
        break;
      case AxisDirection.right:
        childParentData.paintOffset = Offset(
            calculatePaintOffset(constraints,
                from: 0.0, to: resolvedPadding.left),
            resolvedPadding.top);
        break;
      case AxisDirection.down:
        childParentData.paintOffset = Offset(
            resolvedPadding.left,
            calculatePaintOffset(constraints,
                from: 0.0, to: resolvedPadding.top));
        break;
      case AxisDirection.left:
        childParentData.paintOffset = Offset(
            calculatePaintOffset(constraints,
                from: resolvedPadding.right + childLayoutGeometry.scrollExtent,
                to: resolvedPadding.right +
                    childLayoutGeometry.scrollExtent +
                    resolvedPadding.left),
            resolvedPadding.top);
        break;
    }
    assert(childParentData.paintOffset != null);
    assert(beforePadding == this.beforePadding);
    assert(afterPadding == this.afterPadding);
    assert(mainAxisPadding == this.mainAxisPadding);
    assert(crossAxisPadding == this.crossAxisPadding);
  }

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {@required double mainAxisPosition, @required double crossAxisPosition}) {
    if (child != null && child.geometry.hitTestExtent > 0.0) {
      final SliverPhysicalParentData childParentData =
          child.parentData as SliverPhysicalParentData;
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
    switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection)) {
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
    final SliverPhysicalParentData childParentData =
        child.parentData as SliverPhysicalParentData;
    childParentData.applyPaintTransform(transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && child.geometry.visible) {
      final SliverPhysicalParentData childParentData =
          child.parentData as SliverPhysicalParentData;
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
          final SliverPhysicalParentData childParentData =
              child.parentData as SliverPhysicalParentData;
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
