


import 'package:flutter/material.dart';

/// 自定义Tab指示器样式
/// 支持自定义指示器宽度
/// DIY (1) 指示器自定义
/// DIY (2) 指示器颜色跟随页面自定义
class MagicTabIndicator extends Decoration {

  const MagicTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
    this.width = 20,
    @required this.labelColors,
    @required this.pageController,
  }) : assert(borderSide != null),
       assert(insets != null);

  final BorderSide borderSide;

  final EdgeInsetsGeometry insets;

  final double width;
  final TabController pageController;

  final List<Color> labelColors;

  @override
  Decoration lerpFrom(Decoration a, double t) {
    if (a is MagicTabIndicator) {
      return MagicTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration lerpTo(Decoration b, double t) {
    if (b is MagicTabIndicator) {
      return MagicTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([ VoidCallback onChanged ]) {
    return _UnderlinePainter(this, onChanged);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {

    assert(rect != null);
    assert(textDirection != null);
    /// DIY(1) step 2
    // final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    // return Rect.fromLTWH(
    //   indicator.left,
    //   indicator.bottom - borderSide.width,
    //   indicator.width,
    //   borderSide.width,
    // );

    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    double midValue = (indicator.right - indicator.left) / 2 + indicator.left;
    return Rect.fromLTWH(
      midValue - width / 2,
      indicator.bottom - borderSide.width,
      width,
      borderSide.width,
    );
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));

  }
}



double _indexChangeProgress(TabController controller) {
  final double controllerValue = controller.animation.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  // The controller's offset is changing because the user is dragging the
  // TabBarView's PageView to the left or right.
  if (!controller.indexIsChanging)
    return (currentIndex - controllerValue).abs().clamp(0.0, 1.0);

  // The TabController animation's value is changing from previousIndex to currentIndex.
  return (controllerValue - currentIndex).abs() / (currentIndex - previousIndex).abs();
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback onChanged)
    : assert(decoration != null),
      super(onChanged);

  final MagicTabIndicator decoration;


  TabController get pageController => decoration.pageController;

  List<Color> get labelColors => decoration.labelColors;



  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    // Animation<double> colorAnimation = _ChangeAnimation(pageController);

    // final Rect rect = offset & configuration.size!;
    // final TextDirection textDirection = configuration.textDirection!;
    // final Rect indicator = decoration._indicatorRectFor(rect, textDirection).deflate(decoration.borderSide.width / 2.0);
    // final Paint paint = decoration.borderSide.toPaint()..strokeCap = StrokeCap.square;
    // canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);

    /// DIY(2) step 1
    double page = 0;
    int realPage = 0;
    page =  pageController.index + pageController.offset ?? 0;
    realPage = pageController.index +  pageController.offset?.floor() ?? 0;
    double opacity = 1 - (page - realPage).abs();
    Color thisColor = labelColors[realPage];
    thisColor = thisColor;
    Color nextColor = labelColors[
    realPage + 1 < labelColors.length ? realPage + 1 : realPage];
    nextColor =  nextColor;

    /// DIY(1) step 1
    final Rect rect = offset & configuration.size;
    final TextDirection textDirection = configuration.textDirection;
    final Rect indicator = decoration._indicatorRectFor(rect, textDirection).deflate(decoration.borderSide.width / 2.0);
    final Paint paint = decoration.borderSide.toPaint()
      ..strokeCap = StrokeCap.round
      /// DIY(2) step 2
      ..color = Color.lerp(nextColor, thisColor, opacity);
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);

  }
}
