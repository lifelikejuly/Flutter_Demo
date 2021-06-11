import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'photo_view_hit_corners.dart';

class PhotoViewGestureDetector extends StatelessWidget {
  const PhotoViewGestureDetector({
    Key key,
    this.hitDetector,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.onDoubleTap,
    this.child,
    this.onTapUp,
    this.onTapDown,
    this.behavior,
  }) : super(key: key);

  final GestureDoubleTapCallback onDoubleTap;
  final HitCornersDetector hitDetector;

  final GestureScaleStartCallback onScaleStart;
  final GestureScaleUpdateCallback onScaleUpdate;
  final GestureScaleEndCallback onScaleEnd;

  final GestureTapUpCallback onTapUp;
  final GestureTapDownCallback onTapDown;

  final Widget child;

  final HitTestBehavior behavior;

  @override
  Widget build(BuildContext context) {
    final scope = PhotoViewGestureDetectorScope.of(context);

    final Axis axis = scope?.axis;


    final Map<Type, GestureRecognizerFactory> gestures = <Type, GestureRecognizerFactory>{};

    if (onTapDown != null || onTapUp != null) {
      gestures[TapGestureRecognizer] = GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
        () => TapGestureRecognizer(debugOwner: this),
        (TapGestureRecognizer instance) {
          instance
            ..onTapDown = onTapDown
            ..onTapUp = onTapUp;
        },
      );
    }

    gestures[DoubleTapGestureRecognizer] = GestureRecognizerFactoryWithHandlers<DoubleTapGestureRecognizer>(
      () => DoubleTapGestureRecognizer(debugOwner: this),
      (DoubleTapGestureRecognizer instance) {
        instance..onDoubleTap = onDoubleTap;
      },
    );

    gestures[PhotoViewGestureRecognizer] = GestureRecognizerFactoryWithHandlers<PhotoViewGestureRecognizer>(
      () => PhotoViewGestureRecognizer(hitDetector: hitDetector, debugOwner: this, validateAxis: axis),
      (PhotoViewGestureRecognizer instance) {
        instance
          ..onStart = onScaleStart
          ..onUpdate = onScaleUpdate
          ..onEnd = onScaleEnd;
      },
    );

    return RawGestureDetector(
      behavior: behavior,
      child: child,
      gestures: gestures,
    );
  }
}

class PhotoViewGestureRecognizer extends ScaleGestureRecognizer {
  PhotoViewGestureRecognizer({
    this.hitDetector,
    Object debugOwner,
    this.validateAxis,
    PointerDeviceKind kind,
  }) : super(debugOwner: debugOwner, kind: kind);
  final HitCornersDetector hitDetector;
  final Axis validateAxis;

  Map<int, Offset> _pointerLocations = <int, Offset>{};

  Offset _initialFocalPoint;
  Offset _currentFocalPoint;

  bool ready = true;

  /// 缩放手势中，单指拖动时候，一次拖动移动的距离
  int _onePointDragCount;
  Offset _offsetInOnePointDrag;

  @override
  void addAllowedPointer(PointerEvent event) {
    if (ready) {
      ready = false;
      _pointerLocations = <int, Offset>{};
    }
    super.addAllowedPointer(event);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    ready = true;
    super.didStopTrackingLastPointer(pointer);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (validateAxis != null) {
      /// 处理放大之后，单指拖动和滚动视图的问题
      /// 在可以拖动时候，吃掉事件；
      /// 不能拖动时候，交给外出的滚动视图处理
      _computeEvent(event);
      _updateDistances();
      _decideIfWeAcceptEvent(event);
    }
    super.handleEvent(event);
  }

  void _computeEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      if (!event.synthesized) {
        _pointerLocations[event.pointer] = event.position;
      }

      if (_pointerLocations.length == 1) {
        _onePointDragCount += 1;

        if (_onePointDragCount == 1) {
          _offsetInOnePointDrag += event.delta;
        }
      }
    } else if (event is PointerDownEvent) {
      _pointerLocations[event.pointer] = event.position;

      if (_pointerLocations.length == 1) {
        _onePointDragCount = 0;
        _offsetInOnePointDrag = event.delta;
      }
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      _pointerLocations.remove(event.pointer);

      if (_pointerLocations.length == 1) {
        _onePointDragCount = 0;
        _offsetInOnePointDrag = Offset.zero;
      }
    }

    _initialFocalPoint = _currentFocalPoint;
  }

  void _updateDistances() {
    final int count = _pointerLocations.keys.length;
    Offset focalPoint = Offset.zero;
    for (int pointer in _pointerLocations.keys) focalPoint += _pointerLocations[pointer];
    _currentFocalPoint = count > 0 ? focalPoint / count.toDouble() : Offset.zero;
  }

  void _decideIfWeAcceptEvent(PointerEvent event) {
    if (!(event is PointerMoveEvent)) {
      return;
    }

    if (_pointerLocations.keys.length > 1) {
      acceptGesture(event.pointer);
      return;
    }

    final move = _initialFocalPoint - _currentFocalPoint;
    final bool shouldMoveMainAxis = hitDetector.shouldMove(move, validateAxis);
    print("<> gesture shouldMoveMainAxis $shouldMoveMainAxis validateAxis ${validateAxis.toString()}");
    if (shouldMoveMainAxis) {

      Axis crossAxis;
      if (validateAxis == Axis.horizontal) {
        crossAxis = Axis.vertical;
      } else {
        crossAxis = Axis.horizontal;
      }

      final bool shouldMoveCrossAxis = hitDetector.shouldMove(move, crossAxis);
      /// 这里拦截手势操作
      if (shouldMoveCrossAxis) {
        acceptGesture(event.pointer);
        return;
      }

      /// crossAxis已经没有可移动区域了，mainAxis还有，但是用户手势大致是crossAxis的，
      /// 只判断mainAxis交互体验上不好
      /// 我们暂时从第一个点去判断用户拖动的方向
      final double dx = _offsetInOnePointDrag.dx.abs();
      final double dy = _offsetInOnePointDrag.dy.abs();
      if (validateAxis == Axis.horizontal) {
        if (dx > dy) {
          print("<> gesture dx > dy");
          acceptGesture(event.pointer);
          return;
        }
      } else {
        if (dy > dx) {
          print("<> gesture dy > dx");
          acceptGesture(event.pointer);
          return;
        }
      }
    } else {

      if (move.dx == 0) {
        Axis crossAxis;
        if (validateAxis == Axis.horizontal) {
          crossAxis = Axis.vertical;
        } else {
          crossAxis = Axis.horizontal;
        }
        final bool shouldMoveCrossAxis = hitDetector.shouldMove(move, crossAxis);
        if (shouldMoveCrossAxis) {
          acceptGesture(event.pointer);
          return;
        }
      }
    }
  }
}

/// An [InheritedWidget] responsible to give a axis aware scope to [PhotoViewGestureRecognizer].
///
/// When using this, PhotoView will test if the content zoomed has hit edge every time user pinches,
/// if so, it will let parent gesture detectors win the gesture arena
///
/// Useful when placing PhotoView inside a gesture sensitive context,
/// such as [PageView], [Dismissible], [BottomSheet].
///
/// Usage example:
/// ```
/// PhotoViewGestureDetectorScope(
///   axis: Axis.vertical,
///   child: PhotoView(
///     imageProvider: AssetImage("assets/pudim.jpg"),
///   ),
/// );
/// ```
class PhotoViewGestureDetectorScope extends InheritedWidget {
  PhotoViewGestureDetectorScope({
    this.axis,
    @required Widget child,
  }) : super(child: child);

  static PhotoViewGestureDetectorScope of(BuildContext context) {
    final PhotoViewGestureDetectorScope scope =
        context.dependOnInheritedWidgetOfExactType<PhotoViewGestureDetectorScope>();
    return scope;
  }

  final Axis axis;

  @override
  bool updateShouldNotify(PhotoViewGestureDetectorScope oldWidget) {
    return axis != oldWidget.axis;
  }
}
