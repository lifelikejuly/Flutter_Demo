// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// The over-scroll distance that moves the indicator to its maximum
// displacement, as a percentage of the scrollable's container extent.
const double _kDragContainerExtentPercentage = 0.25;

// How much the scroll's drag gesture can overshoot the SidePullIndicator's
// displacement; max displacement = _kDragSizeFactorLimit * displacement.
const double _kDragSizeFactorLimit = 1.5;

// When the scroll ends, the duration of the refresh indicator's animation
// to the SidePullIndicator's displacement.
const Duration _kIndicatorSnapDuration = Duration(milliseconds: 150);

// The duration of the ScaleTransition that starts when the refresh action
// has completed.
const Duration _kIndicatorScaleDuration = Duration(milliseconds: 100);

/// The signature for a function that's called when the user has dragged a
/// [SidePullIndicator] far enough to demonstrate that they want the app to
/// refresh. The returned [Future] must complete when the refresh operation is
/// finished.
///
/// Used by [SidePullIndicator.onRefresh].
typedef RefreshCallback = Future<void> Function();

// The state machine moves through these modes only when the scrollable
// identified by scrollableKey has been scrolled to its min or max limit.
enum _SidePullIndicatorMode {
  drag, // Pointer is down.
  armed, // Dragged far enough that an up event will run the onRefresh callback.
  snap, // Animating to the indicator's final "displacement".
  refresh, // Running the refresh callback.
  done, // Animating the indicator's fade-out after refreshing.
  canceled, // Animating the indicator's fade-out after not arming.
}

class SidePullIndicator extends StatefulWidget {
  const SidePullIndicator(
      {Key key,
      @required this.child,
      @required this.onRefresh,
      this.notificationPredicate = defaultScrollNotificationPredicate,
      this.semanticsLabel,
      this.semanticsValue})
      : assert(child != null),
        assert(onRefresh != null),
        assert(notificationPredicate != null),
        super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// The refresh indicator will be stacked on top of this child. The indicator
  /// will appear when child's Scrollable descendant is over-scrolled.
  ///
  /// Typically a [ListView] or [CustomScrollView].
  final Widget child;


  /// A function that's called when the user has dragged the refresh indicator
  /// far enough to demonstrate that they want the app to refresh. The returned
  /// [Future] must complete when the refresh operation is finished.
  final RefreshCallback onRefresh;

  /// A check that specifies whether a [ScrollNotification] should be
  /// handled by this widget.
  ///
  /// By default, checks whether `notification.depth == 0`. Set it to something
  /// else for more complicated layouts.
  final ScrollNotificationPredicate notificationPredicate;

  /// {@macro flutter.material.progressIndicator.semanticsLabel}
  ///
  /// This will be defaulted to [MaterialLocalizations.SidePullIndicatorSemanticLabel]
  /// if it is null.
  final String semanticsLabel;

  /// {@macro flutter.material.progressIndicator.semanticsValue}
  final String semanticsValue;

  @override
  SidePullIndicatorState createState() => SidePullIndicatorState();
}

/// Contains the state for a [SidePullIndicator]. This class can be used to
/// programmatically show the refresh indicator, see the [show] method.
class SidePullIndicatorState extends State<SidePullIndicator>
    with TickerProviderStateMixin<SidePullIndicator> {
  AnimationController _positionController;

  _SidePullIndicatorMode _mode;
  Future<void> _pendingRefreshFuture;
  bool _isIndicatorAtTop;
  double _dragOffset;


  @override
  void initState() {
    super.initState();
    _positionController = AnimationController(vsync: this);
  }


  @override
  void dispose() {
    _positionController.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.notificationPredicate(notification)) return false;
    if (notification is ScrollStartNotification &&
        notification.metrics.extentAfter == 0 &&
        _mode == null &&
        _start(notification.metrics.axisDirection)) {
      setState(() {
        _mode = _SidePullIndicatorMode.drag;
      });
      return false;
    }
    bool indicatorAtTopNow;
    switch (notification.metrics.axisDirection) { // 修改点
      case AxisDirection.right: // 右侧滑动
        indicatorAtTopNow = true;
        break;
      case AxisDirection.left: // 左侧滑动
        indicatorAtTopNow = false;
        break;
      case AxisDirection.up: // 其他方向屏蔽
      case AxisDirection.down:
        indicatorAtTopNow = null;
        break;
    }
    if (indicatorAtTopNow != _isIndicatorAtTop) {
      if (_mode == _SidePullIndicatorMode.drag ||
          _mode == _SidePullIndicatorMode.armed)
        _dismiss(_SidePullIndicatorMode.canceled);
    } else if (notification is ScrollUpdateNotification) {
      if (_mode == _SidePullIndicatorMode.drag ||
          _mode == _SidePullIndicatorMode.armed) {
        if (notification.metrics.extentAfter > 0.0) {
          _dismiss(_SidePullIndicatorMode.canceled);
        } else {
          _dragOffset -= notification.scrollDelta;
          _checkDragOffset(notification.metrics.viewportDimension);
        }
      }
      if (_mode == _SidePullIndicatorMode.armed &&
          notification.dragDetails == null) {
        // On iOS start the refresh when the Scrollable bounces back from the
        // overscroll (ScrollNotification indicating this don't have dragDetails
        // because the scroll activity is not directly triggered by a drag).
        _show();
      }
    } else if (notification is OverscrollNotification) {
      if (_mode == _SidePullIndicatorMode.drag ||
          _mode == _SidePullIndicatorMode.armed) {
        _dragOffset -= notification.overscroll / 2.0;
        _checkDragOffset(notification.metrics.viewportDimension);
      }
    } else if (notification is ScrollEndNotification) {
      switch (_mode) {
        case _SidePullIndicatorMode.armed:
          _show();
          break;
        case _SidePullIndicatorMode.drag:
          _dismiss(_SidePullIndicatorMode.canceled);
          break;
        default:
          // do nothing
          break;
      }
    }
    print("<><>  _mode ${_mode} end _dragOffset $_dragOffset notification $notification");
    return false;
  }

  bool _start(AxisDirection direction) { // 修改点
    assert(_mode == null);
    assert(_isIndicatorAtTop == null);
    // assert(_dragOffset == null);
    switch (direction) {
      case AxisDirection.right:
        _isIndicatorAtTop = true;
        break;
      case AxisDirection.left:
        _isIndicatorAtTop = false;
        break;
      case AxisDirection.up:
      case AxisDirection.down:
        _isIndicatorAtTop = null;
        // we do not support horizontal scroll views.
        return false;
    }
    _dragOffset = 0.0;
    _positionController.value = 0.0;
    return true;
  }

  void _checkDragOffset(double containerExtent) { // 修改点
    assert(_mode == _SidePullIndicatorMode.drag ||
        _mode == _SidePullIndicatorMode.armed);
    double newValue =
        _dragOffset / (containerExtent * _kDragContainerExtentPercentage);
    if (_mode == _SidePullIndicatorMode.armed)
      newValue = math.max(newValue, 1.0 / _kDragSizeFactorLimit);
    _positionController.value =
        newValue.clamp(0.0, 1.0) as double; // this triggers various rebuilds
    // 侧滑距离大小来触发是否缩回事件
    if (_mode == _SidePullIndicatorMode.drag &&
        ((_dragOffset ?? 0) < -70)) //_valueColor.value.alpha == 0xFF)
      _mode = _SidePullIndicatorMode.armed;
  }

  // Stop showing the refresh indicator.
  Future<void> _dismiss(_SidePullIndicatorMode newMode) async {
    await Future<void>.value();
    // This can only be called from _show() when refreshing and
    // _handleScrollNotification in response to a ScrollEndNotification or
    // direction change.
    assert(newMode == _SidePullIndicatorMode.canceled ||
        newMode == _SidePullIndicatorMode.done);
    setState(() {
      _mode = newMode;
    });
    switch (_mode) {
      case _SidePullIndicatorMode.done:
        _positionController.value = 0.0;
        // await _positionController.animateTo(0.0,
        //     duration: _kIndicatorScaleDuration);
        break;
      case _SidePullIndicatorMode.canceled:
        _positionController.value = 0.0;
        // await _positionController.animateTo(0.0,
        //     duration: _kIndicatorScaleDuration);
        break;
      default:
        assert(false);
    }
    if (mounted && _mode == newMode) {
      _isIndicatorAtTop = null;
      setState(() {
        _mode = null;
      });
    }
  }

  void _show() {
    assert(_mode != _SidePullIndicatorMode.refresh);
    assert(_mode != _SidePullIndicatorMode.snap);
    final Completer<void> completer = Completer<void>();
    _pendingRefreshFuture = completer.future;
    _mode = _SidePullIndicatorMode.snap;
    _positionController
        .animateTo(1.0 / _kDragSizeFactorLimit,
            duration: _kIndicatorSnapDuration)
        .then<void>((void value) {
      if (mounted && _mode == _SidePullIndicatorMode.snap) {
        assert(widget.onRefresh != null);
        setState(() {
          // Show the indeterminate progress indicator.
          _mode = _SidePullIndicatorMode.refresh;
        });

        final Future<void> refreshResult = widget.onRefresh();
        assert(() {
          if (refreshResult == null)
            FlutterError.reportError(FlutterErrorDetails(
              exception: FlutterError('The onRefresh callback returned null.\n'
                  'The SidePullIndicator onRefresh callback must return a Future.'),
              context: ErrorDescription('when calling onRefresh'),
              library: 'material library',
            ));
          return true;
        }());
        if (refreshResult == null) return;
        refreshResult.whenComplete(() {
          if (mounted && _mode == _SidePullIndicatorMode.refresh) {
            completer.complete();
            _dismiss(_SidePullIndicatorMode.done);
          }
        });
      }
    });
  }

  // /// Show the refresh indicator and run the refresh callback as if it had
  // /// been started interactively. If this method is called while the refresh
  // /// callback is running, it quietly does nothing.
  // ///
  // /// Creating the [SidePullIndicator] with a [GlobalKey<SidePullIndicatorState>]
  // /// makes it possible to refer to the [SidePullIndicatorState].
  // ///
  // /// The future returned from this method completes when the
  // /// [SidePullIndicator.onRefresh] callback's future completes.
  // ///
  // /// If you await the future returned by this function from a [State], you
  // /// should check that the state is still [mounted] before calling [setState].
  // ///
  // /// When initiated in this manner, the refresh indicator is independent of any
  // /// actual scroll view. It defaults to showing the indicator at the top. To
  // /// show it at the bottom, set `atTop` to false.
  // Future<void> show({bool atTop = true}) {
  //   if (_mode != _SidePullIndicatorMode.refresh &&
  //       _mode != _SidePullIndicatorMode.snap) {
  //     if (_mode == null)
  //       _start(atTop ? AxisDirection.right : AxisDirection.left);
  //     _show();
  //   }
  //   return _pendingRefreshFuture;
  // }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final Widget child = NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: widget.child,
    );
    assert(() {
      if (_mode == null) {
        // assert(_dragOffset == null);
        assert(_isIndicatorAtTop == null);
      } else {
        assert(_dragOffset != null);
        assert(_isIndicatorAtTop != null);
      }
      return true;
    }());

    return Stack(
      children: <Widget>[
        child,
        if (_mode != null)
          AnimatedBuilder(
            animation: _positionController,
            builder: (BuildContext context, Widget child) {
              return Positioned(
                right: -75,
                child: Container(
                  padding: EdgeInsets.only(left: 30),
                  alignment: Alignment.center,
                  width: 75 - ((_dragOffset ?? 0.0) > 0.0 ? 0.0 : _dragOffset),
                  height: 175,
                  decoration: BoxDecoration(
                    color: Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        "images/icon_left_sliver.png",
                        width: 15,
                        height: 15,
                      ),
                      SizedBox(width: 7),
                      Text(
                        "滑\n动\n查\n看\n更\n多",
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                            fontWeight: FontWeight.w400,
                            fontFamily: "PingFang SC"),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
