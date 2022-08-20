part of 'nested_scroll_view.dart';

class NestedScrollViewX extends _NestedScrollView {
  const NestedScrollViewX({
    Key key,
    ScrollController controller,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollPhysics physics,
    @required _NestedScrollViewHeaderSliversBuilder headerSliverBuilder,
    @required Widget body,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    bool floatHeaderSlivers = false,
    Clip clipBehavior = Clip.hardEdge,
    String restorationId,
    ScrollBehavior scrollBehavior,
  }) : super(
          key: key,
          controller: controller,
          scrollDirection: scrollDirection,
          reverse: reverse,
          physics: physics,
          headerSliverBuilder: headerSliverBuilder,
          body: body,
          dragStartBehavior: dragStartBehavior,
          floatHeaderSlivers: floatHeaderSlivers,
          clipBehavior: clipBehavior,
          restorationId: restorationId,
          scrollBehavior: scrollBehavior,
        );

  static _SliverOverlapAbsorberHandle sliverOverlapAbsorberHandleFor(
      BuildContext context) {
    final _InheritedNestedScrollView target = context
        .dependOnInheritedWidgetOfExactType<_InheritedNestedScrollView>();
    assert(
      target != null,
      '_NestedScrollView.sliverOverlapAbsorberHandleFor must be called with a context that contains a _NestedScrollView.',
    );
    return target.state._absorberHandle;
  }

  @override
  _NestedScrollViewState createState() => _NestedScrollViewStateX();
}

class _NestedScrollViewStateX extends _NestedScrollViewState {
  @override
  void initState() {
    super.initState();
    _coordinator = _NestedScrollCoordinatorX(
      this,
      widget.controller,
      _handleHasScrolledBodyChanged,
      widget.floatHeaderSlivers,
    );
  }
}

class _NestedScrollControllerX extends _NestedScrollController {
  _NestedScrollControllerX(
    _NestedScrollCoordinatorX coordinator, {
    double initialScrollOffset = 0.0,
    String debugLabel,
  }) : super(coordinator,
            initialScrollOffset: initialScrollOffset, debugLabel: debugLabel);

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition oldPosition,
  ) {
    return _NestedScrollPositionX(
      coordinator: coordinator as _NestedScrollCoordinatorX,
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }

  @override
  Iterable<_NestedScrollPosition> get nestedPositions =>
      kDebugMode ? _debugNestedPositions : _releaseNestedPositions;

  Iterable<_NestedScrollPosition> get _debugNestedPositions {
    return Iterable.castFrom<ScrollPosition, _NestedScrollPosition>(positions);
  }

  Iterable<_NestedScrollPosition> get _releaseNestedPositions sync* {
    yield* Iterable.castFrom<ScrollPosition, _NestedScrollPosition>(positions);
  }
}

class _NestedScrollCoordinatorX extends _NestedScrollCoordinator {
  _NestedScrollCoordinatorX(
    _NestedScrollViewStateX state,
    ScrollController parent,
    VoidCallback onHasScrolledBodyChanged,
    bool floatHeaderSlivers,
  ) : super(state, parent, onHasScrolledBodyChanged, floatHeaderSlivers) {
    final double initialScrollOffset = _parent?.initialScrollOffset ?? 0.0;
    _outerController = _NestedScrollControllerX(
      this,
      initialScrollOffset: initialScrollOffset,
      debugLabel: 'outer',
    );
    _innerController = _NestedScrollControllerX(
      this,
      initialScrollOffset: 0.0,
      debugLabel: 'inner',
    );
  }

  ///内部列表位置
  _NestedScrollPosition get _innerPosition {
    if (!_innerController.hasClients ||
        _innerController.nestedPositions.isEmpty) return null;
    _NestedScrollPosition innerPosition;
    if (userScrollDirection != ScrollDirection.idle) {
      for (final _NestedScrollPosition position in _innerPositions) {
        if (innerPosition != null) {
          //上滑
          if (userScrollDirection == ScrollDirection.reverse) {
            if (innerPosition.pixels < position.pixels) continue;
          } else {
            if (innerPosition.pixels > position.pixels) continue;
          }
        }
        innerPosition = position;
      }
    }
    return innerPosition;
  }

  @override
  _NestedScrollMetrics _getMetrics(
      _NestedScrollPosition innerPosition, double velocity) {
    /// 《》 原方法有很多判断
    return _NestedScrollMetrics(
      minScrollExtent: _outerPosition.minScrollExtent,
      maxScrollExtent: _outerPosition.maxScrollExtent +
          (innerPosition.maxScrollExtent - innerPosition.minScrollExtent),
      pixels: unnestOffset(innerPosition.pixels, innerPosition),
      viewportDimension: _outerPosition.viewportDimension,
      axisDirection: _outerPosition.axisDirection,
      minRange: 0,
      maxRange: 0,
      correctionOffset: 0,
    );
  }

  /// in/out -> coordinator
  @override
  double unnestOffset(double value, _NestedScrollPosition source) {
    /// 《》 原方法
    // if (source == _outerPosition)
    //   return value.clamp(
    //     _outerPosition.minScrollExtent,
    //     _outerPosition.maxScrollExtent,
    //   );
    // if (value < source.minScrollExtent)
    //   return value - source.minScrollExtent + _outerPosition.minScrollExtent;
    // return value - source.minScrollExtent + _outerPosition.maxScrollExtent;

    if (source == _outerPosition) {
      return value;
    } else {
      if (_outerPosition.maxScrollExtent - _outerPosition.pixels >
          precisionErrorTolerance) {
        ///outer在滚动，以outer位置为基准
        return _outerPosition.pixels;
      }
      return _outerPosition.maxScrollExtent + (value - source.minScrollExtent);
    }
  }

  /// coordinator -> in/out
  @override
  double nestOffset(double value, _NestedScrollPosition target) {
    /// 《》 原方法
    // if (target == _outerPosition)
    //   return value.clamp(
    //     _outerPosition.minScrollExtent,
    //     _outerPosition.maxScrollExtent,
    //   );
    // if (value < _outerPosition.minScrollExtent)
    //   return value - _outerPosition.minScrollExtent + target.minScrollExtent;
    // if (value > _outerPosition.maxScrollExtent)
    //   return value - _outerPosition.maxScrollExtent + target.minScrollExtent;
    // return target.minScrollExtent;

    if (target == _outerPosition) {
      if (value > _outerPosition.maxScrollExtent) {
        //不允许outer底部overscroll
        return _outerPosition.maxScrollExtent;
      }
      return value;
    } else {
      if (value < _outerPosition.maxScrollExtent) {
        //不允许inner顶部overscroll
        return target.minScrollExtent;
      }
      return (target.minScrollExtent +
          (value - _outerPosition.maxScrollExtent));
    }
  }

  @override
  void applyUserOffset(double delta) {
    updateUserScrollDirection(
        delta > 0.0 ? ScrollDirection.forward : ScrollDirection.reverse);
    if (_innerPositions.isEmpty) {
      _outerPosition.applyFullDragUpdate(delta);
    } else if (delta < 0.0) {
      double outerDelta = delta;
      for (final _NestedScrollPosition position in _innerPositions) {
        if (position.pixels < position.minScrollExtent) {
          final double potentialOuterDelta =
              position.applyClampedDragUpdate(delta);
          if (potentialOuterDelta < 0) {
            outerDelta = math.max(outerDelta, potentialOuterDelta);
          }
        }
      }
      if (outerDelta != 0.0) {
        final double innerDelta = _outerPosition.applyClampedDragUpdate(
          outerDelta,
        );
        if (innerDelta != 0.0) {
          for (final _NestedScrollPosition position in _innerPositions)
            position.applyFullDragUpdate(innerDelta);
        }
      }
    } else {
      double innerDelta = delta;
      if (_floatHeaderSlivers) {
        innerDelta = _outerPosition.applyClampedDragUpdate(delta);
      }
      if (innerDelta != 0.0) {
        /// 《》  不处理 overScroll
        double outerDelta = 0.0;
        for (final _NestedScrollPosition position in _innerPositions) {
          final double overscroll = position.applyClampedDragUpdate(innerDelta);
          if (overscroll > 0) {
            outerDelta = math.max(outerDelta, overscroll);
          }
        }
        if (outerDelta != 0.0) {
          _outerPosition.applyFullDragUpdate(outerDelta);
        }
      }
    }
  }
}

class _NestedScrollPositionX extends _NestedScrollPosition {
  _NestedScrollPositionX({
    @required ScrollPhysics physics,
    @required ScrollContext context,
    double initialPixels = 0.0,
    ScrollPosition oldPosition,
    String debugLabel,
    @required _NestedScrollCoordinatorX coordinator,
  }) : super(
            physics: physics,
            context: context,
            initialPixels: initialPixels,
            oldPosition: oldPosition,
            debugLabel: debugLabel,
            coordinator: coordinator);

  @override
  ScrollActivity createBallisticScrollActivity(
    Simulation simulation, {
    @required _NestedBallisticScrollActivityMode mode,
    _NestedScrollMetrics metrics,
  }) {
    if (simulation == null) return IdleScrollActivity(this);
    switch (mode) {
      case _NestedBallisticScrollActivityMode.outer:
        return _NestedOuterBallisticScrollActivityX(
          coordinator,
          this,
          simulation,
          context.vsync,
        );
      case _NestedBallisticScrollActivityMode.inner:
        return _NestedInnerBallisticScrollActivityX(
          coordinator,
          this,
          simulation,
          context.vsync,
        );
      case _NestedBallisticScrollActivityMode.independent:
        return BallisticScrollActivity(this, simulation, context.vsync);
    }
  }
}

class _NestedBallisticScrollActivityX extends BallisticScrollActivity {
  _NestedBallisticScrollActivityX(
    this.coordinator,
    _NestedScrollPosition position,
    Simulation simulation,
    TickerProvider vsync,
  ) : super(position, simulation, vsync);

  final _NestedScrollCoordinator coordinator;

  @override
  _NestedScrollPosition get delegate => super.delegate as _NestedScrollPosition;

  @override
  void resetActivity() {
    assert(false);
  }

  @override
  void applyNewDimensions() {
    assert(false);
  }

  @override
  bool applyMoveTo(double value) {
    return super.applyMoveTo(coordinator.nestOffset(value, delegate));
  }
}

class _NestedOuterBallisticScrollActivityX
    extends _NestedBallisticScrollActivityX {
  _NestedOuterBallisticScrollActivityX(
    _NestedScrollCoordinator coordinator,
    _NestedScrollPosition position,
    Simulation simulation,
    TickerProvider vsync,
  ) : super(coordinator, position, simulation, vsync);

  @override
  void resetActivity() {
    delegate.beginActivity(coordinator.createOuterBallisticScrollActivity(
      velocity,
    ));
  }

  @override
  void applyNewDimensions() {
    delegate.beginActivity(coordinator.createOuterBallisticScrollActivity(
      velocity,
    ));
  }
}

class _NestedInnerBallisticScrollActivityX
    extends _NestedBallisticScrollActivityX {
  _NestedInnerBallisticScrollActivityX(
    _NestedScrollCoordinator coordinator,
    _NestedScrollPosition position,
    Simulation simulation,
    TickerProvider vsync,
  ) : super(coordinator, position, simulation, vsync);

  @override
  void resetActivity() {
    delegate.beginActivity(coordinator.createInnerBallisticScrollActivity(
      delegate,
      velocity,
    ));
  }

  @override
  void applyNewDimensions() {
    delegate.beginActivity(coordinator.createInnerBallisticScrollActivity(
      delegate,
      velocity,
    ));
  }
}

class SliverOverlapAbsorberX extends _SliverOverlapAbsorber {
  SliverOverlapAbsorberX({
    Key key,
    @required _SliverOverlapAbsorberHandle handle,
    Widget sliver,
  }) : super(
          key: key,
          handle: handle,
          sliver: sliver,
        );

  @override
  _RenderSliverOverlapAbsorber createRenderObject(BuildContext context) {
    return _RenderSliverOverlapAbsorberX(
      handle: handle,
    );
  }
}

class _RenderSliverOverlapAbsorberX extends _RenderSliverOverlapAbsorber {
  _RenderSliverOverlapAbsorberX({
    @required _SliverOverlapAbsorberHandle handle,
    RenderSliver sliver,
  }) : super(handle: handle, sliver: sliver);

  @override
  void performLayout() {
    assert(
      handle._writers == 1,
      'A _SliverOverlapAbsorberHandle cannot be passed to multiple _RenderSliverOverlapAbsorber objects at the same time.',
    );
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    child.layout(constraints, parentUsesSize: true);
    final SliverGeometry childLayoutGeometry = child.geometry;
    final maxExtent = childLayoutGeometry.scrollExtent;
    final minExtent = childLayoutGeometry.maxScrollObstructionExtent;
    final topOverscroll =
        childLayoutGeometry.paintExtent > childLayoutGeometry.scrollExtent;
    final topOverscrollExtend =
        (childLayoutGeometry.paintExtent - childLayoutGeometry.scrollExtent)
            .clamp(0, double.infinity);
    final absorbsExtend =
        topOverscroll ? 0.0 : childLayoutGeometry.maxScrollObstructionExtent;
    geometry = SliverGeometry(
      scrollExtent: childLayoutGeometry.scrollExtent -
          absorbsExtend -
          topOverscrollExtend,
      paintExtent: childLayoutGeometry.paintExtent,
      paintOrigin: childLayoutGeometry.paintOrigin,
      layoutExtent:
          childLayoutGeometry.paintExtent - absorbsExtend - topOverscrollExtend,
      maxPaintExtent: childLayoutGeometry.maxPaintExtent,
      maxScrollObstructionExtent:
          childLayoutGeometry.maxScrollObstructionExtent,
      hitTestExtent: childLayoutGeometry.hitTestExtent,
      visible: childLayoutGeometry.visible,
      hasVisualOverflow: childLayoutGeometry.hasVisualOverflow,
      scrollOffsetCorrection: childLayoutGeometry.scrollOffsetCorrection,
    );
    handle._setExtents(
      absorbsExtend,
      absorbsExtend,
    );
  }
}

class SliverOverlapInjectorX extends _SliverOverlapInjector {
  SliverOverlapInjectorX({
    Key key,
    @required _SliverOverlapAbsorberHandle handle,
    Widget sliver,
  }) : super(
          key: key,
          handle: handle,
          sliver: sliver,
        );

  @override
  _RenderSliverOverlapInjector createRenderObject(BuildContext context) {
    return _RenderSliverOverlapInjectorX(
      handle: handle,
    );
  }
}

class _RenderSliverOverlapInjectorX extends _RenderSliverOverlapInjector {
  _RenderSliverOverlapInjectorX({
    @required _SliverOverlapAbsorberHandle handle,
  }) : super(handle: handle);
}
