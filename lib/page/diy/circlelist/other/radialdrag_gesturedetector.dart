import 'dart:math';

import 'package:flutter/material.dart';

/// Gesture detector that reports user drags in terms of [PolarCoord]s with the
/// origin at the center of the provided [child].
///
/// [PolarCoord]s are comprised of an angle and a radius (distance).
///
/// Use [onRadialDragStart], [onRadialDragUpdate], and [onRadialDragEnd] to
/// react to the respective radial drag events.
class RadialDragGestureDetector extends StatefulWidget {
  final RadialDragStart onRadialDragStart;
  final RadialDragUpdate onRadialDragUpdate;
  final RadialDragEnd onRadialDragEnd;
  final Widget child;
  final bool stopRotate;

  RadialDragGestureDetector({
    this.onRadialDragStart,
    this.onRadialDragUpdate,
    this.onRadialDragEnd,
    this.child,
    this.stopRotate = false,
  });

  @override
  _RadialDragGestureDetectorState createState() =>
      _RadialDragGestureDetectorState();
}

class _RadialDragGestureDetectorState extends State<RadialDragGestureDetector> {
  _onPanStart(DragStartDetails details) {
    if (null != widget.onRadialDragStart) {
      final polarCoord = _polarCoordFromGlobalOffset(details.globalPosition);
      widget.onRadialDragStart(polarCoord);
    }
  }

  _onPanUpdate(DragUpdateDetails details) {
    if (null != widget.onRadialDragUpdate) {
      final polarCoord = _polarCoordFromGlobalOffset(details.globalPosition);
      widget.onRadialDragUpdate(polarCoord);
    }
  }

  _onPanEnd(DragEndDetails details) {
    if (null != widget.onRadialDragEnd) {
      widget.onRadialDragEnd();
    }
  }

  _polarCoordFromGlobalOffset(globalOffset) {
    // Convert the user's global touch offset to an offset that is local to
    // this Widget.
    final localTouchOffset =
        (context.findRenderObject() as RenderBox).globalToLocal(globalOffset);

    // Convert the local offset to a Point so that we can do math with it.
    final localTouchPoint = Point(localTouchOffset.dx, localTouchOffset.dy);

    // Create a Point at the center of this Widget to act as the origin.
    final originPoint =
        Point(context.size.width / 2, context.size.height / 2);

    return PolarCoord.fromPoints(originPoint, localTouchPoint);
  }

  @override
  Widget build(BuildContext context) {
    return widget.stopRotate
        ? widget.child
        : GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: widget.child,
          );
  }
}

class PolarCoord {
  double angle;
  double radius;
  Offset origin;
  Offset point;

  factory PolarCoord.fromPoints(Point origin, Point point) {
    // Subtract the origin from the point to get the vector from the origin
    // to the point.
    final vectorPoint = point - origin;
    final vector = Offset(vectorPoint.x as double, vectorPoint.y as double);

    // The polar coordinate is the angle the vector forms with the x-axis, and
    // the distance of the vector.
    return PolarCoord(
      vector.direction,
      vector.distance,
      Offset(origin.x as double, origin.y as double),
      Offset(point.x as double, point.y as double),
    );
  }

  PolarCoord(this.angle, this.radius, this.origin, this.point);

  @override
  toString() {
    return 'Polar Coord: ${radius.toStringAsFixed(2)}' +
        ' at ${(angle / (2 * pi) * 360).toStringAsFixed(2)}°';
  }
}

typedef RadialDragStart = Function(PolarCoord startCoord);
typedef RadialDragUpdate = Function(PolarCoord updateCoord);
typedef RadialDragEnd = Function();

enum RotateMode {
  onlyChildrenRotate,
  allRotate,
  stopRotate,
}

class DragAngleRange {
  double start, end;

  DragAngleRange(this.start, this.end);
}