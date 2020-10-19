

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class DIYColoredBox extends SingleChildRenderObjectWidget {
  /// Creates a widget that paints its area with the specified [Color].
  ///
  /// The [color] parameter must not be null.
  const DIYColoredBox({@required this.color, Widget child, Key key})
      : assert(color != null),
        super(key: key, child: child);

  /// The color to paint the background area with.
  final Color color;

  @override
  _RenderColoredBox createRenderObject(BuildContext context) {
    return _RenderColoredBox(color: color);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderColoredBox renderObject) {
    renderObject.color = color;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Color>('color', color));
  }
}

class _RenderColoredBox extends RenderProxyBoxWithHitTestBehavior {
  _RenderColoredBox({@required Color color})
      : _color = color,
        super(behavior: HitTestBehavior.opaque);

  /// The fill color for this render object.
  ///
  /// This parameter must not be null.
  Color get color => _color;
  Color _color;
  set color(Color value) {
    assert(value != null);
    if (value == _color) {
      return;
    }
    _color = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (size > Size.zero) {
      print("DIYColoredBox size ${size.toString()} $offset");
//      context.canvas.drawRect(offset & size, Paint()..color = color);
      RRect rrect = RRect.fromRectAndRadius(Offset(offset.dx,offset.dy) & size, Radius.circular(20.0));
      context.canvas..drawRRect(rrect, Paint()..color = color);
    }
//    offset = Offset(offset.dx,offset.dy + 100);
    if (child != null) {
      context.paintChild(child, offset);
    }
  }
}