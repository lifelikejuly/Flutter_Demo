part of 'nested_scroll_view.dart';

class NestedScrollViewY extends _NestedScrollView {
  const NestedScrollViewY({
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
  _NestedScrollViewState createState() => _NestedScrollViewStateY();
}

class _NestedScrollViewStateY extends _NestedScrollViewState {
  @override
  void initState() {
    super.initState();
    _coordinator = _NestedScrollCoordinatorY(
      this,
      widget.controller,
      _handleHasScrolledBodyChanged,
      widget.floatHeaderSlivers,
    );
  }
}

class _NestedScrollControllerY extends _NestedScrollController {
  _NestedScrollControllerY(
    _NestedScrollCoordinatorY coordinator, {
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
    return _NestedScrollPositionY(
      coordinator: coordinator as _NestedScrollCoordinatorY,
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

class _NestedScrollCoordinatorY extends _NestedScrollCoordinator {
  _NestedScrollCoordinatorY(
    _NestedScrollViewStateY state,
    ScrollController parent,
    VoidCallback onHasScrolledBodyChanged,
    bool floatHeaderSlivers,
  ) : super(state, parent, onHasScrolledBodyChanged, floatHeaderSlivers) {
    final double initialScrollOffset = _parent?.initialScrollOffset ?? 0.0;
    _outerController = _NestedScrollControllerY(
      this,
      initialScrollOffset: initialScrollOffset,
      debugLabel: 'outer',
    );
    _innerController = _NestedScrollControllerY(
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
    if (source == _outerPosition) {
      return value.clamp(
        _outerPosition.minScrollExtent,
        _outerPosition.maxScrollExtent,
      );
    }
    if (_outerPosition.maxScrollExtent - _outerPosition.pixels >
            precisionErrorTolerance &&
        (_outerPosition.pixels - _outerPosition.minScrollExtent) >
            precisionErrorTolerance) {
      ///outer在滚动，以outer位置为基准
      return _outerPosition.pixels.clamp(
        _outerPosition.minScrollExtent,
        _outerPosition.maxScrollExtent,
      );
    }
    if (value <= source.minScrollExtent)
      return value - source.minScrollExtent + _outerPosition.minScrollExtent;
    return value - source.minScrollExtent + _outerPosition.maxScrollExtent;
  }
}

class _NestedScrollPositionY extends _NestedScrollPosition {
  _NestedScrollPositionY({
    @required ScrollPhysics physics,
    @required ScrollContext context,
    double initialPixels = 0.0,
    ScrollPosition oldPosition,
    String debugLabel,
    @required _NestedScrollCoordinatorY coordinator,
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
        return _NestedOuterBallisticScrollActivityY(
          coordinator,
          this,
          simulation,
          context.vsync,
        );
      case _NestedBallisticScrollActivityMode.inner:
        return _NestedInnerBallisticScrollActivityY(
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

class _NestedBallisticScrollActivityY extends BallisticScrollActivity {
  _NestedBallisticScrollActivityY(
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

class _NestedOuterBallisticScrollActivityY
    extends _NestedBallisticScrollActivityY {
  _NestedOuterBallisticScrollActivityY(
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

class _NestedInnerBallisticScrollActivityY
    extends _NestedBallisticScrollActivityY {
  _NestedInnerBallisticScrollActivityY(
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

class SliverOverlapAbsorberY extends _SliverOverlapAbsorber {
  SliverOverlapAbsorberY({
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
    return _RenderSliverOverlapAbsorberY(
      handle: handle,
    );
  }
}

class _RenderSliverOverlapAbsorberY extends _RenderSliverOverlapAbsorber {
  _RenderSliverOverlapAbsorberY({
    @required _SliverOverlapAbsorberHandle handle,
    RenderSliver sliver,
  }) : super(handle: handle, sliver: sliver);
}

class SliverOverlapInjectorY extends _SliverOverlapInjector {
  SliverOverlapInjectorY({
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
    return _RenderSliverOverlapInjectorY(
      handle: handle,
    );
  }
}

class _RenderSliverOverlapInjectorY extends _RenderSliverOverlapInjector {
  _RenderSliverOverlapInjectorY({
    @required _SliverOverlapAbsorberHandle handle,
  }) : super(handle: handle);
}
