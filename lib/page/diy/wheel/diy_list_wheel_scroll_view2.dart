// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import 'diy_list_wheel_viewport2.dart';
import 'diy_list_wheel_viewport2.dart';


/// A delegate that supplies children for [DIY2ListWheelScrollView].
///
/// [DIY2ListWheelScrollView] lazily constructs its children during layout to avoid
/// creating more children than are visible through the [Viewport]. This
/// delegate is responsible for providing children to [DIY2ListWheelScrollView]
/// during that stage.
///
/// See also:
///
///  * [DIY2ListWheelChildListDelegate], a delegate that supplies children using an
///    explicit list.
///  * [DIY2ListWheelChildLoopingListDelegate], a delegate that supplies infinite
///    children by looping an explicit list.
///  * [DIY2ListWheelChildBuilderDelegate], a delegate that supplies children using
///    a builder callback.
abstract class DIY2ListWheelChildDelegate {
  /// Return the child at the given index. If the child at the given
  /// index does not exist, return null.
  Widget build(BuildContext context, int index);

  /// Returns an estimate of the number of children this delegate will build.
  int get estimatedChildCount;

  /// Returns the true index for a child built at a given index. Defaults to
  /// the given index, however if the delegate is [DIY2ListWheelChildLoopingListDelegate],
  /// this value is the index of the true element that the delegate is looping to.
  ///
  ///
  /// Example: [DIY2ListWheelChildLoopingListDelegate] is built by looping a list of
  /// length 8. Then, trueIndexOf(10) = 2 and trueIndexOf(-5) = 3.
  int trueIndexOf(int index) => index;

  /// Called to check whether this and the old delegate are actually 'different',
  /// so that the caller can decide to rebuild or not.
  bool shouldRebuild(covariant DIY2ListWheelChildDelegate oldDelegate);
}

/// A delegate that supplies children for [DIY2ListWheelScrollView] using an
/// explicit list.
///
/// [DIY2ListWheelScrollView] lazily constructs its children to avoid creating more
/// children than are visible through the [Viewport]. This delegate provides
/// children using an explicit list, which is convenient but reduces the benefit
/// of building children lazily.
///
/// In general building all the widgets in advance is not efficient. It is
/// better to create a delegate that builds them on demand using
/// [DIY2ListWheelChildBuilderDelegate] or by subclassing [DIY2ListWheelChildDelegate]
/// directly.
///
/// This class is provided for the cases where either the list of children is
/// known well in advance (ideally the children are themselves compile-time
/// constants, for example), and therefore will not be built each time the
/// delegate itself is created, or the list is small, such that it's likely
/// always visible (and thus there is nothing to be gained by building it on
/// demand). For example, the body of a dialog box might fit both of these
/// conditions.
class DIY2ListWheelChildListDelegate extends DIY2ListWheelChildDelegate {
  /// Constructs the delegate from a concrete list of children.
  DIY2ListWheelChildListDelegate({@required this.children}) : assert(children != null);

  /// The list containing all children that can be supplied.
  final List<Widget> children;

  @override
  int get estimatedChildCount => children.length;

  @override
  Widget build(BuildContext context, int index) {
    if (index < 0 || index >= children.length)
      return null;
    return IndexedSemantics(index: index, child: children[index]);
  }

  @override
  bool shouldRebuild(covariant DIY2ListWheelChildListDelegate oldDelegate) {
    return children != oldDelegate.children;
  }
}

/// A delegate that supplies infinite children for [DIY2ListWheelScrollView] by
/// looping an explicit list.
///
/// [DIY2ListWheelScrollView] lazily constructs its children to avoid creating more
/// children than are visible through the [Viewport]. This delegate provides
/// children using an explicit list, which is convenient but reduces the benefit
/// of building children lazily.
///
/// In general building all the widgets in advance is not efficient. It is
/// better to create a delegate that builds them on demand using
/// [DIY2ListWheelChildBuilderDelegate] or by subclassing [DIY2ListWheelChildDelegate]
/// directly.
///
/// This class is provided for the cases where either the list of children is
/// known well in advance (ideally the children are themselves compile-time
/// constants, for example), and therefore will not be built each time the
/// delegate itself is created, or the list is small, such that it's likely
/// always visible (and thus there is nothing to be gained by building it on
/// demand). For example, the body of a dialog box might fit both of these
/// conditions.
class DIY2ListWheelChildLoopingListDelegate extends DIY2ListWheelChildDelegate {
  /// Constructs the delegate from a concrete list of children.
  DIY2ListWheelChildLoopingListDelegate({@required this.children}) : assert(children != null);

  /// The list containing all children that can be supplied.
  final List<Widget> children;

  @override
  int get estimatedChildCount => null;

  @override
  int trueIndexOf(int index) => index % children.length;

  @override
  Widget build(BuildContext context, int index) {
    if (children.isEmpty)
      return null;
    return IndexedSemantics(index: index, child: children[index % children.length]);
  }

  @override
  bool shouldRebuild(covariant DIY2ListWheelChildLoopingListDelegate oldDelegate) {
    return children != oldDelegate.children;
  }
}

/// A delegate that supplies children for [DIY2ListWheelScrollView] using a builder
/// callback.
///
/// [DIY2ListWheelScrollView] lazily constructs its children to avoid creating more
/// children than are visible through the [Viewport]. This delegate provides
/// children using an [IndexedWidgetBuilder] callback, so that the children do
/// not have to be built until they are displayed.
class DIY2ListWheelChildBuilderDelegate extends DIY2ListWheelChildDelegate {
  /// Constructs the delegate from a builder callback.
  DIY2ListWheelChildBuilderDelegate({
    @required this.builder,
    this.childCount,
  }) : assert(builder != null);

  /// Called lazily to build children.
  final NullableIndexedWidgetBuilder builder;

  /// {@template flutter.widgets.DIY2ListWheelChildBuilderDelegate.childCount}
  /// If non-null, [childCount] is the maximum number of children that can be
  /// provided, and children are available from 0 to [childCount] - 1.
  ///
  /// If null, then the lower and upper limit are not known. However the [builder]
  /// must provide children for a contiguous segment. If the builder returns null
  /// at some index, the segment terminates there.
  /// {@endtemplate}
  final int childCount;

  @override
  int get estimatedChildCount => childCount;

  @override
  Widget build(BuildContext context, int index) {
    if (childCount == null) {
      final Widget child = builder(context, index);
      return child == null ? null : IndexedSemantics(index: index, child: child);
    }
    if (index < 0 || index >= childCount)
      return null;
    return IndexedSemantics(index: index, child: builder(context, index));
  }

  @override
  bool shouldRebuild(covariant DIY2ListWheelChildBuilderDelegate oldDelegate) {
    return builder != oldDelegate.builder || childCount != oldDelegate.childCount;
  }
}

/// A controller for scroll views whose items have the same size.
///
/// Similar to a standard [ScrollController] but with the added convenience
/// mechanisms to read and go to item indices rather than a raw pixel scroll
/// offset.
///
/// See also:
///
///  * [DIY2ListWheelScrollView], a scrollable view widget with fixed size items
///    that this widget controls.
///  * [FixedExtentMetrics], the `metrics` property exposed by
///    [ScrollNotification] from [DIY2ListWheelScrollView] which can be used
///    to listen to the current item index on a push basis rather than polling
///    the [DIY2FixedExtentScrollController].
class DIY2FixedExtentScrollController extends ScrollController {
  /// Creates a scroll controller for scrollables whose items have the same size.
  ///
  /// [initialItem] defaults to 0 and must not be null.
  DIY2FixedExtentScrollController({
    this.initialItem = 0,
  }) : assert(initialItem != null);

  /// The page to show when first creating the scroll view.
  ///
  /// Defaults to 0 and must not be null.
  final int initialItem;

  /// The currently selected item index that's closest to the center of the viewport.
  ///
  /// There are circumstances that this [DIY2FixedExtentScrollController] can't know
  /// the current item. Reading [selectedItem] will throw an [AssertionError] in
  /// the following cases:
  ///
  /// 1. No scroll view is currently using this [DIY2FixedExtentScrollController].
  /// 2. More than one scroll views using the same [DIY2FixedExtentScrollController].
  ///
  /// The [hasClients] property can be used to check if a scroll view is
  /// attached prior to accessing [selectedItem].
  int get selectedItem {
    assert(
      positions.isNotEmpty,
      'DIY2FixedExtentScrollController.selectedItem cannot be accessed before a '
      'scroll view is built with it.',
    );
    assert(
      positions.length == 1,
      'The selectedItem property cannot be read when multiple scroll views are '
      'attached to the same DIY2FixedExtentScrollController.',
    );
    final _FixedExtentScrollPosition position = this.position as _FixedExtentScrollPosition;
    return position.itemIndex;
  }

  /// Animates the controlled scroll view to the given item index.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  ///
  /// The `duration` and `curve` arguments must not be null.
  Future<void> animateToItem(
    int itemIndex, {
    @required Duration duration,
    @required Curve curve,
  }) async {
    if (!hasClients) {
      return;
    }

    await Future.wait<void>(<Future<void>>[
      for (final _FixedExtentScrollPosition position in positions.cast<_FixedExtentScrollPosition>())
        position.animateTo(
          itemIndex * position.itemExtent,
          duration: duration,
          curve: curve,
        ),
    ]);
  }

  /// Changes which item index is centered in the controlled scroll view.
  ///
  /// Jumps the item index position from its current value to the given value,
  /// without animation, and without checking if the new value is in range.
  void jumpToItem(int itemIndex) {
    for (final _FixedExtentScrollPosition position in positions.cast<_FixedExtentScrollPosition>()) {
      position.jumpTo(itemIndex * position.itemExtent);
    }
  }

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition oldPosition) {
    return _FixedExtentScrollPosition(
      physics: physics,
      context: context,
      initialItem: initialItem,
      oldPosition: oldPosition,
    );
  }
}

/// Metrics for a [ScrollPosition] to a scroll view with fixed item sizes.
///
/// The metrics are available on [ScrollNotification]s generated from a scroll
/// views such as [DIY2ListWheelScrollView]s with a [DIY2FixedExtentScrollController]
/// and exposes the current [itemIndex] and the scroll view's extents.
///
/// `FixedExtent` refers to the fact that the scrollable items have the same
/// size. This is distinct from `Fixed` in the parent class name's
/// [FixedScrollMetrics] which refers to its immutability.
class FixedExtentMetrics extends FixedScrollMetrics {
  /// Creates an immutable snapshot of values associated with a
  /// [DIY2ListWheelScrollView].
  FixedExtentMetrics({
    @required double minScrollExtent,
    @required double maxScrollExtent,
    @required double pixels,
    @required double viewportDimension,
    @required AxisDirection axisDirection,
    @required this.itemIndex,
  }) : super(
         minScrollExtent: minScrollExtent,
         maxScrollExtent: maxScrollExtent,
         pixels: pixels,
         viewportDimension: viewportDimension,
         axisDirection: axisDirection,
       );

  @override
  FixedExtentMetrics copyWith({
    double minScrollExtent,
    double maxScrollExtent,
    double pixels,
    double viewportDimension,
    AxisDirection axisDirection,
    int itemIndex,
  }) {
    return FixedExtentMetrics(
      minScrollExtent: minScrollExtent ?? (hasContentDimensions ? this.minScrollExtent : null),
      maxScrollExtent: maxScrollExtent ?? (hasContentDimensions ? this.maxScrollExtent : null),
      pixels: pixels ?? (hasPixels ? this.pixels : null),
      viewportDimension: viewportDimension ?? (hasViewportDimension ? this.viewportDimension : null),
      axisDirection: axisDirection ?? this.axisDirection,
      itemIndex: itemIndex ?? this.itemIndex,
    );
  }

  /// The scroll view's currently selected item index.
  final int itemIndex;
}

int _getItemFromOffset({
  @required double offset,
  @required double itemExtent,
  @required double minScrollExtent,
  @required double maxScrollExtent,
}) {
  return (_clipOffsetToScrollableRange(offset, minScrollExtent, maxScrollExtent) / itemExtent).round();
}

double _clipOffsetToScrollableRange(
  double offset,
  double minScrollExtent,
  double maxScrollExtent,
) {
  return math.min(math.max(offset, minScrollExtent), maxScrollExtent);
}

/// A [ScrollPositionWithSingleContext] that can only be created based on
/// [_FixedExtentScrollable] and can access its `itemExtent` to derive [itemIndex].
class _FixedExtentScrollPosition extends ScrollPositionWithSingleContext implements FixedExtentMetrics {
  _FixedExtentScrollPosition({
    @required ScrollPhysics physics,
    @required ScrollContext context,
    @required int initialItem,
    bool keepScrollOffset = true,
    ScrollPosition oldPosition,
    String debugLabel,
  }) : assert(
         context is _FixedExtentScrollableState,
         'DIY2FixedExtentScrollController can only be used with DIY2ListWheelScrollViews',
       ),
       super(
         physics: physics,
         context: context,
         initialPixels: _getItemExtentFromScrollContext(context) * initialItem,
         keepScrollOffset: keepScrollOffset,
         oldPosition: oldPosition,
         debugLabel: debugLabel,
       );

  static double _getItemExtentFromScrollContext(ScrollContext context) {
    final _FixedExtentScrollableState scrollable = context as _FixedExtentScrollableState;
    return scrollable.itemExtent;
  }

  double get itemExtent => _getItemExtentFromScrollContext(context);

  @override
  int get itemIndex {
    return _getItemFromOffset(
      offset: pixels,
      itemExtent: itemExtent,
      minScrollExtent: minScrollExtent,
      maxScrollExtent: maxScrollExtent,
    );
  }

  @override
  FixedExtentMetrics copyWith({
    double minScrollExtent,
    double maxScrollExtent,
    double pixels,
    double viewportDimension,
    AxisDirection axisDirection,
    int itemIndex,
  }) {
    return FixedExtentMetrics(
      minScrollExtent: minScrollExtent ?? (hasContentDimensions ? this.minScrollExtent : null),
      maxScrollExtent: maxScrollExtent ?? (hasContentDimensions ? this.maxScrollExtent : null),
      pixels: pixels ?? (hasPixels ? this.pixels : null),
      viewportDimension: viewportDimension ?? (hasViewportDimension ? this.viewportDimension : null),
      axisDirection: axisDirection ?? this.axisDirection,
      itemIndex: itemIndex ?? this.itemIndex,
    );
  }
}

/// A [Scrollable] which must be given its viewport children's item extent
/// size so it can pass it on ultimately to the [DIY2FixedExtentScrollController].
class _FixedExtentScrollable extends Scrollable {
  const _FixedExtentScrollable({
    Key key,
    // DIY step1 滑动方向修改
    // AxisDirection axisDirection = AxisDirection.down,
    AxisDirection axisDirection = AxisDirection.left,
    ScrollController controller,
    ScrollPhysics physics,
    @required this.itemExtent,
    @required ViewportBuilder viewportBuilder,
    String restorationId,
    ScrollBehavior scrollBehavior,
  }) : super (
    key: key,
    axisDirection: axisDirection,
    controller: controller,
    physics: physics,
    viewportBuilder: viewportBuilder,
    restorationId: restorationId,
    scrollBehavior: scrollBehavior,
  );

  final double itemExtent;

  @override
  _FixedExtentScrollableState createState() => _FixedExtentScrollableState();
}

/// This [ScrollContext] is used by [_FixedExtentScrollPosition] to read the
/// prescribed [itemExtent].
class _FixedExtentScrollableState extends ScrollableState {
  double get itemExtent {
    // Downcast because only _FixedExtentScrollable can make _FixedExtentScrollableState.
    final _FixedExtentScrollable actualWidget = widget as _FixedExtentScrollable;
    return actualWidget.itemExtent;
  }
}

/// A snapping physics that always lands directly on items instead of anywhere
/// within the scroll extent.
///
/// Behaves similarly to a slot machine wheel except the ballistics simulation
/// never overshoots and rolls back within a single item if it's to settle on
/// that item.
///
/// Must be used with a scrollable that uses a [DIY2FixedExtentScrollController].
///
/// Defers back to the parent beyond the scroll extents.
class DIY2FixedExtentScrollPhysics extends ScrollPhysics {
  /// Creates a scroll physics that always lands on items.
  const DIY2FixedExtentScrollPhysics({ ScrollPhysics parent }) : super(parent: parent);

  @override
  DIY2FixedExtentScrollPhysics applyTo(ScrollPhysics ancestor) {
    return DIY2FixedExtentScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    assert(
      position is _FixedExtentScrollPosition,
      'DIY2FixedExtentScrollPhysics can only be used with Scrollables that uses '
      'the DIY2FixedExtentScrollController',
    );

    final _FixedExtentScrollPosition metrics = position as _FixedExtentScrollPosition;

    // Scenario 1:
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at the scrollable's boundary.
    if ((velocity <= 0.0 && metrics.pixels <= metrics.minScrollExtent) ||
        (velocity >= 0.0 && metrics.pixels >= metrics.maxScrollExtent)) {
      return super.createBallisticSimulation(metrics, velocity);
    }

    // Create a test simulation to see where it would have ballistically fallen
    // naturally without settling onto items.
    final Simulation testFrictionSimulation =
        super.createBallisticSimulation(metrics, velocity);

    // Scenario 2:
    // If it was going to end up past the scroll extent, defer back to the
    // parent physics' ballistics again which should put us on the scrollable's
    // boundary.
    if (testFrictionSimulation != null
        && (testFrictionSimulation.x(double.infinity) == metrics.minScrollExtent
            || testFrictionSimulation.x(double.infinity) == metrics.maxScrollExtent)) {
      return super.createBallisticSimulation(metrics, velocity);
    }

    // From the natural final position, find the nearest item it should have
    // settled to.
    final int settlingItemIndex = _getItemFromOffset(
      offset: testFrictionSimulation?.x(double.infinity) ?? metrics.pixels,
      itemExtent: metrics.itemExtent,
      minScrollExtent: metrics.minScrollExtent,
      maxScrollExtent: metrics.maxScrollExtent,
    );

    final double settlingPixels = settlingItemIndex * metrics.itemExtent;

    // Scenario 3:
    // If there's no velocity and we're already at where we intend to land,
    // do nothing.
    if (velocity.abs() < tolerance.velocity
        && (settlingPixels - metrics.pixels).abs() < tolerance.distance) {
      return null;
    }

    // Scenario 4:
    // If we're going to end back at the same item because initial velocity
    // is too low to break past it, use a spring simulation to get back.
    if (settlingItemIndex == metrics.itemIndex) {
      return SpringSimulation(
        spring,
        metrics.pixels,
        settlingPixels,
        velocity,
        tolerance: tolerance,
      );
    }

    // Scenario 5:
    // Create a new friction simulation except the drag will be tweaked to land
    // exactly on the item closest to the natural stopping point.
    return FrictionSimulation.through(
      metrics.pixels,
      settlingPixels,
      velocity,
      tolerance.velocity * velocity.sign,
    );
  }
}

/// A box in which children on a wheel can be scrolled.
///
/// This widget is similar to a [ListView] but with the restriction that all
/// children must be the same size along the scrolling axis.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=dUhmWAz4C7Y}
///
/// When the list is at the zero scroll offset, the first child is aligned with
/// the middle of the viewport. When the list is at the final scroll offset,
/// the last child is aligned with the middle of the viewport.
///
/// The children are rendered as if rotating on a wheel instead of scrolling on
/// a plane.
class DIY2ListWheelScrollView extends StatefulWidget {
  /// Constructs a list in which children are scrolled a wheel. Its children
  /// are passed to a delegate and lazily built during layout.
  DIY2ListWheelScrollView({
    Key key,
    this.controller,
    this.physics,
    this.diameterRatio = RenderDIY2ListWheelViewport.defaultDiameterRatio,
    this.perspective = RenderDIY2ListWheelViewport.defaultPerspective,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.overAndUnderCenterOpacity = 1.0,
    @required this.itemExtent,
    this.squeeze = 1.0,
    this.onSelectedItemChanged,
    this.renderChildrenOutsideViewport = false,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scrollBehavior,
    @required List<Widget> children,
  }) : assert(children != null),
       assert(diameterRatio != null),
       assert(diameterRatio > 0.0, RenderDIY2ListWheelViewport.diameterRatioZeroMessage),
       assert(perspective != null),
       assert(perspective > 0),
       assert(perspective <= 0.01, RenderDIY2ListWheelViewport.perspectiveTooHighMessage),
       assert(magnification > 0),
       assert(overAndUnderCenterOpacity != null),
       assert(overAndUnderCenterOpacity >= 0 && overAndUnderCenterOpacity <= 1),
       assert(itemExtent != null),
       assert(itemExtent > 0),
       assert(squeeze != null),
       assert(squeeze > 0),
       assert(renderChildrenOutsideViewport != null),
       assert(clipBehavior != null),
       assert(
         !renderChildrenOutsideViewport || clipBehavior == Clip.none,
         RenderDIY2ListWheelViewport.clipBehaviorAndRenderChildrenOutsideViewportConflict,
       ),
       childDelegate = DIY2ListWheelChildListDelegate(children: children),
       super(key: key);

  /// Constructs a list in which children are scrolled a wheel. Its children
  /// are managed by a delegate and are lazily built during layout.
  const DIY2ListWheelScrollView.useDelegate({
    Key key,
    this.controller,
    this.physics,
    this.diameterRatio = RenderDIY2ListWheelViewport.defaultDiameterRatio,
    this.perspective = RenderDIY2ListWheelViewport.defaultPerspective,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.overAndUnderCenterOpacity = 1.0,
    @required this.itemExtent,
    this.squeeze = 1.0,
    this.onSelectedItemChanged,
    this.renderChildrenOutsideViewport = false,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scrollBehavior,
    @required this.childDelegate,
  }) : assert(childDelegate != null),
       assert(diameterRatio != null),
       assert(diameterRatio > 0.0, RenderDIY2ListWheelViewport.diameterRatioZeroMessage),
       assert(perspective != null),
       assert(perspective > 0),
       assert(perspective <= 0.01, RenderDIY2ListWheelViewport.perspectiveTooHighMessage),
       assert(magnification > 0),
       assert(overAndUnderCenterOpacity != null),
       assert(overAndUnderCenterOpacity >= 0 && overAndUnderCenterOpacity <= 1),
       assert(itemExtent != null),
       assert(itemExtent > 0),
       assert(squeeze != null),
       assert(squeeze > 0),
       assert(renderChildrenOutsideViewport != null),
       assert(clipBehavior != null),
       assert(
         !renderChildrenOutsideViewport || clipBehavior == Clip.none,
         RenderDIY2ListWheelViewport.clipBehaviorAndRenderChildrenOutsideViewportConflict,
       ),
       super(key: key);

  /// Typically a [DIY2FixedExtentScrollController] used to control the current item.
  ///
  /// A [DIY2FixedExtentScrollController] can be used to read the currently
  /// selected/centered child item and can be used to change the current item.
  ///
  /// If none is provided, a new [DIY2FixedExtentScrollController] is implicitly
  /// created.
  ///
  /// If a [ScrollController] is used instead of [DIY2FixedExtentScrollController],
  /// [ScrollNotification.metrics] will no longer provide [FixedExtentMetrics]
  /// to indicate the current item index and [onSelectedItemChanged] will not
  /// work.
  ///
  /// To read the current selected item only when the value changes, use
  /// [onSelectedItemChanged].
  final ScrollController controller;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// If an explicit [ScrollBehavior] is provided to [scrollBehavior], the
  /// [ScrollPhysics] provided by that behavior will take precedence after
  /// [physics].
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics physics;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.diameterRatio}
  final double diameterRatio;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.perspective}
  final double perspective;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.offAxisFraction}
  final double offAxisFraction;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.useMagnifier}
  final bool useMagnifier;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.magnification}
  final double magnification;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.overAndUnderCenterOpacity}
  final double overAndUnderCenterOpacity;

  /// Size of each child in the main axis. Must not be null and must be
  /// positive.
  final double itemExtent;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.squeeze}
  ///
  /// Defaults to 1.
  final double squeeze;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<int> onSelectedItemChanged;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.renderChildrenOutsideViewport}
  final bool renderChildrenOutsideViewport;

  /// A delegate that helps lazily instantiating child.
  final DIY2ListWheelChildDelegate childDelegate;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String restorationId;

  /// {@macro flutter.widgets.shadow.scrollBehavior}
  ///
  /// [ScrollBehavior]s also provide [ScrollPhysics]. If an explicit
  /// [ScrollPhysics] is provided in [physics], it will take precedence,
  /// followed by [scrollBehavior], and then the inherited ancestor
  /// [ScrollBehavior].
  ///
  /// The [ScrollBehavior] of the inherited [ScrollConfiguration] will be
  /// modified by default to not apply a [Scrollbar].
  final ScrollBehavior scrollBehavior;

  @override
  State<DIY2ListWheelScrollView> createState() => _DIY2ListWheelScrollViewState();
}

class _DIY2ListWheelScrollViewState extends State<DIY2ListWheelScrollView> {
  int _lastReportedItemIndex = 0;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = widget.controller ?? DIY2FixedExtentScrollController();
    if (widget.controller is DIY2FixedExtentScrollController) {
      final DIY2FixedExtentScrollController controller = widget.controller as DIY2FixedExtentScrollController;
      _lastReportedItemIndex = controller.initialItem;
    }
  }

  @override
  void didUpdateWidget(DIY2ListWheelScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && widget.controller != scrollController) {
      final ScrollController oldScrollController = scrollController;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        oldScrollController.dispose();
      });
      scrollController = widget.controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.depth == 0
            && widget.onSelectedItemChanged != null
            && notification is ScrollUpdateNotification
            && notification.metrics is FixedExtentMetrics) {
          final FixedExtentMetrics metrics = notification.metrics as FixedExtentMetrics;
          final int currentItemIndex = metrics.itemIndex;
          if (currentItemIndex != _lastReportedItemIndex) {
            _lastReportedItemIndex = currentItemIndex;
            final int trueIndex = widget.childDelegate.trueIndexOf(currentItemIndex);
            widget.onSelectedItemChanged(trueIndex);
          }
        }
        return false;
      },
      child: _FixedExtentScrollable(
        controller: scrollController,
        physics: widget.physics,
        itemExtent: widget.itemExtent,
        restorationId: widget.restorationId,
        scrollBehavior: widget.scrollBehavior ?? ScrollConfiguration.of(context).copyWith(scrollbars: false),
        viewportBuilder: (BuildContext context, ViewportOffset offset) {
          return DIY2ListWheelViewport(
            diameterRatio: widget.diameterRatio,
            perspective: widget.perspective,
            offAxisFraction: widget.offAxisFraction,
            useMagnifier: widget.useMagnifier,
            magnification: widget.magnification,
            overAndUnderCenterOpacity: widget.overAndUnderCenterOpacity,
            itemExtent: widget.itemExtent,
            squeeze: widget.squeeze,
            renderChildrenOutsideViewport: widget.renderChildrenOutsideViewport,
            offset: offset,
            childDelegate: widget.childDelegate,
            clipBehavior: widget.clipBehavior,
          );
        },
      ),
    );
  }
}

/// Element that supports building children lazily for [DIY2ListWheelViewport].
class DIY2ListWheelElement extends RenderObjectElement implements ListWheelChildManager {
  /// Creates an element that lazily builds children for the given widget.
  DIY2ListWheelElement(DIY2ListWheelViewport widget) : super(widget);

  @override
  DIY2ListWheelViewport get widget => super.widget as DIY2ListWheelViewport;

  @override
  RenderDIY2ListWheelViewport get renderObject => super.renderObject as RenderDIY2ListWheelViewport;

  // We inflate widgets at two different times:
  //  1. When we ourselves are told to rebuild (see performRebuild).
  //  2. When our render object needs a new child (see createChild).
  // In both cases, we cache the results of calling into our delegate to get the
  // widget, so that if we do case 2 later, we don't call the builder again.
  // Any time we do case 1, though, we reset the cache.

  /// A cache of widgets so that we don't have to rebuild every time.
  final Map<int, Widget> _childWidgets = HashMap<int, Widget>();

  /// The map containing all active child elements. SplayTreeMap is used so that
  /// we have all elements ordered and iterable by their keys.
  final SplayTreeMap<int, Element> _childElements = SplayTreeMap<int, Element>();

  @override
  void update(DIY2ListWheelViewport newWidget) {
    final DIY2ListWheelViewport oldWidget = widget;
    super.update(newWidget);
    final DIY2ListWheelChildDelegate newDelegate = newWidget.childDelegate;
    final DIY2ListWheelChildDelegate oldDelegate = oldWidget.childDelegate;
    if (newDelegate != oldDelegate &&
        (newDelegate.runtimeType != oldDelegate.runtimeType || newDelegate.shouldRebuild(oldDelegate))) {
      performRebuild();
      renderObject.markNeedsLayout();
    }
  }

  @override
  int get childCount => widget.childDelegate.estimatedChildCount;

  @override
  void performRebuild() {
    _childWidgets.clear();
    super.performRebuild();
    if (_childElements.isEmpty)
      return;

    final int firstIndex = _childElements.firstKey();
    final int lastIndex = _childElements.lastKey();

    for (int index = firstIndex; index <= lastIndex; ++index) {
      final Element newChild = updateChild(_childElements[index], retrieveWidget(index), index);
      if (newChild != null) {
        _childElements[index] = newChild;
      } else {
        _childElements.remove(index);
      }
    }
  }

  /// Asks the underlying delegate for a widget at the given index.
  ///
  /// Normally the builder is only called once for each index and the result
  /// will be cached. However when the element is rebuilt, the cache will be
  /// cleared.
  Widget retrieveWidget(int index) {
    return _childWidgets.putIfAbsent(index, () => widget.childDelegate.build(this, index));
  }

  @override
  bool childExistsAt(int index) => retrieveWidget(index) != null;

  @override
  void createChild(int index, { @required RenderBox after }) {
    owner.buildScope(this, () {
      final bool insertFirst = after == null;
      assert(insertFirst || _childElements[index - 1] != null);
      final Element newChild =
        updateChild(_childElements[index], retrieveWidget(index), index);
      if (newChild != null) {
        _childElements[index] = newChild;
      } else {
        _childElements.remove(index);
      }
    });
  }

  @override
  void removeChild(RenderBox child) {
    final int index = renderObject.indexOf(child);
    owner.buildScope(this, () {
      assert(_childElements.containsKey(index));
      final Element result = updateChild(_childElements[index], null, index);
      assert(result == null);
      _childElements.remove(index);
      assert(!_childElements.containsKey(index));
    });
  }

  @override
  Element updateChild(Element child, Widget newWidget, Object newSlot) {
    final ListWheelParentData oldParentData = child?.renderObject?.parentData as ListWheelParentData;
    final Element newChild = super.updateChild(child, newWidget, newSlot);
    final ListWheelParentData newParentData = newChild?.renderObject?.parentData as ListWheelParentData;
    if (newParentData != null) {
      newParentData.index = newSlot as int;
      if (oldParentData != null)
        newParentData.offset = oldParentData.offset;
    }

    return newChild;
  }

  @override
  void insertRenderObjectChild(RenderObject child, int slot) {
    final RenderDIY2ListWheelViewport renderObject = this.renderObject;
    assert(renderObject.debugValidateChild(child));
    renderObject.insert(child as RenderBox, after: _childElements[slot - 1]?.renderObject as RenderBox);
    assert(renderObject == this.renderObject);
  }

  @override
  void moveRenderObjectChild(RenderObject child, int oldSlot, int newSlot) {
    const String moveChildRenderObjectErrorMessage =
        'Currently we maintain the list in contiguous increasing order, so '
        'moving children around is not allowed.';
    assert(false, moveChildRenderObjectErrorMessage);
  }

  @override
  void removeRenderObjectChild(RenderObject child, int slot) {
    assert(child.parent == renderObject);
    renderObject.remove(child as RenderBox);
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    _childElements.forEach((int key, Element child) {
      visitor(child);
    });
  }

  @override
  void forgetChild(Element child) {
    _childElements.remove(child.slot);
    super.forgetChild(child);
  }

}

/// A viewport showing a subset of children on a wheel.
///
/// Typically used with [DIY2ListWheelScrollView], this viewport is similar to
/// [Viewport] in that it shows a subset of children in a scrollable based
/// on the scrolling offset and the children's dimensions. But uses
/// [RenderDIY2ListWheelViewport] to display the children on a wheel.
///
/// See also:
///
///  * [DIY2ListWheelScrollView], widget that combines this viewport with a scrollable.
///  * [RenderDIY2ListWheelViewport], the render object that renders the children
///    on a wheel.
class DIY2ListWheelViewport extends RenderObjectWidget {
  /// Creates a viewport where children are rendered onto a wheel.
  ///
  /// The [diameterRatio] argument defaults to 2.0 and must not be null.
  ///
  /// The [perspective] argument defaults to 0.003 and must not be null.
  ///
  /// The [itemExtent] argument in pixels must be provided and must be positive.
  ///
  /// The [clipBehavior] argument defaults to [Clip.hardEdge] and must not be null.
  ///
  /// The [renderChildrenOutsideViewport] argument defaults to false and must
  /// not be null.
  ///
  /// The [offset] argument must be provided and must not be null.
  const DIY2ListWheelViewport({
    Key key,
    this.diameterRatio = RenderDIY2ListWheelViewport.defaultDiameterRatio,
    this.perspective = RenderDIY2ListWheelViewport.defaultPerspective,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.overAndUnderCenterOpacity = 1.0,
    @required this.itemExtent,
    this.squeeze = 1.0,
    this.renderChildrenOutsideViewport = false,
    @required this.offset,
    @required this.childDelegate,
    this.clipBehavior = Clip.hardEdge,
  }) : assert(childDelegate != null),
       assert(offset != null),
       assert(diameterRatio != null),
       assert(diameterRatio > 0, RenderDIY2ListWheelViewport.diameterRatioZeroMessage),
       assert(perspective != null),
       assert(perspective > 0),
       assert(perspective <= 0.01, RenderDIY2ListWheelViewport.perspectiveTooHighMessage),
       assert(overAndUnderCenterOpacity != null),
       assert(overAndUnderCenterOpacity >= 0 && overAndUnderCenterOpacity <= 1),
       assert(itemExtent != null),
       assert(itemExtent > 0),
       assert(squeeze != null),
       assert(squeeze > 0),
       assert(renderChildrenOutsideViewport != null),
       assert(clipBehavior != null),
       assert(
         !renderChildrenOutsideViewport || clipBehavior == Clip.none,
         RenderDIY2ListWheelViewport.clipBehaviorAndRenderChildrenOutsideViewportConflict,
       ),
       super(key: key);

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.diameterRatio}
  final double diameterRatio;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.perspective}
  final double perspective;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.offAxisFraction}
  final double offAxisFraction;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.useMagnifier}
  final bool useMagnifier;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.magnification}
  final double magnification;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.overAndUnderCenterOpacity}
  final double overAndUnderCenterOpacity;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.itemExtent}
  final double itemExtent;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.squeeze}
  ///
  /// Defaults to 1.
  final double squeeze;

  /// {@macro flutter.rendering.RenderDIY2ListWheelViewport.renderChildrenOutsideViewport}
  final bool renderChildrenOutsideViewport;

  /// [ViewportOffset] object describing the content that should be visible
  /// in the viewport.
  final ViewportOffset offset;

  /// A delegate that lazily instantiates children.
  final DIY2ListWheelChildDelegate childDelegate;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  @override
  DIY2ListWheelElement createElement() => DIY2ListWheelElement(this);

  @override
  RenderDIY2ListWheelViewport createRenderObject(BuildContext context) {
    final DIY2ListWheelElement childManager = context as DIY2ListWheelElement;
    return RenderDIY2ListWheelViewport(
      childManager: childManager,
      offset: offset,
      diameterRatio: diameterRatio,
      perspective: perspective,
      offAxisFraction: offAxisFraction,
      useMagnifier: useMagnifier,
      magnification: magnification,
      overAndUnderCenterOpacity: overAndUnderCenterOpacity,
      itemExtent: itemExtent,
      squeeze: squeeze,
      renderChildrenOutsideViewport: renderChildrenOutsideViewport,
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderDIY2ListWheelViewport renderObject) {
    renderObject
      ..offset = offset
      ..diameterRatio = diameterRatio
      ..perspective = perspective
      ..offAxisFraction = offAxisFraction
      ..useMagnifier = useMagnifier
      ..magnification = magnification
      ..overAndUnderCenterOpacity = overAndUnderCenterOpacity
      ..itemExtent = itemExtent
      ..squeeze = squeeze
      ..renderChildrenOutsideViewport = renderChildrenOutsideViewport
      ..clipBehavior = clipBehavior;
  }
}
