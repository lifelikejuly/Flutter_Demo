import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/page/common/common.dart';

/// 首页滑动列表一些自定义个性化定制组件

/// SliverAppBar的DIYFlexibleSpaceBar改造 伸缩时背景色变化定制
class DIYFlexibleSpaceBar extends StatefulWidget {
  /// Creates a flexible space bar.
  ///
  /// Most commonly used in the [AppBar.flexibleSpace] field.
  const DIYFlexibleSpaceBar({
    Key key,
    this.title,
    this.pageController,
    this.background,
    this.centerTitle,
    this.titlePadding,
    this.collapseMode = CollapseMode.parallax,
    this.stretchModes = const <StretchMode>[StretchMode.zoomBackground],
  })  : assert(collapseMode != null),
        super(key: key);

  /// The primary contents of the flexible space bar when expanded.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Shown behind the [title] when expanded.
  ///
  /// Typically an [Image] widget with [Image.fit] set to [BoxFit.cover].
  final Widget background;

  /// Whether the title should be centered.
  ///
  /// By default this property is true if the current target platform
  /// is [TargetPlatform.iOS] or [TargetPlatform.macOS], false otherwise.
  final bool centerTitle;

  /// Collapse effect while scrolling.
  ///
  /// Defaults to [CollapseMode.parallax].
  final CollapseMode collapseMode;

  /// Stretch effect while over-scrolling,
  ///
  /// Defaults to include [StretchMode.zoomBackground].
  final List<StretchMode> stretchModes;

  final PageController pageController;

  /// Defines how far the [title] is inset from either the widget's
  /// bottom-left or its center.
  ///
  /// Typically this property is used to adjust how far the title is
  /// is inset from the bottom-left and it is specified along with
  /// [centerTitle] false.
  ///
  /// By default the value of this property is
  /// `EdgeInsetsDirectional.only(start: 72, bottom: 16)` if the title is
  /// not centered, `EdgeInsetsDirectional.only(start: 0, bottom: 16)` otherwise.
  final EdgeInsetsGeometry titlePadding;

  /// Wraps a widget that contains an [AppBar] to convey sizing information down
  /// to the [DIYFlexibleSpaceBar].
  ///
  /// Used by [Scaffold] and [SliverAppBar].
  ///
  /// `toolbarOpacity` affects how transparent the text within the toolbar
  /// appears. `minExtent` sets the minimum height of the resulting
  /// [DIYFlexibleSpaceBar] when fully collapsed. `maxExtent` sets the maximum
  /// height of the resulting [DIYFlexibleSpaceBar] when fully expanded.
  /// `currentExtent` sets the scale of the [DIYFlexibleSpaceBar.background] and
  /// [DIYFlexibleSpaceBar.title] widgets of [DIYFlexibleSpaceBar] upon
  /// initialization.
  ///
  /// See also:
  ///
  ///  * [FlexibleSpaceBarSettings] which creates a settings object that can be
  ///    used to specify these settings to a [DIYFlexibleSpaceBar].
  static Widget createSettings({
    double toolbarOpacity,
    double minExtent,
    double maxExtent,
    @required double currentExtent,
    @required Widget child,
  }) {
    assert(currentExtent != null);
    return FlexibleSpaceBarSettings(
      toolbarOpacity: toolbarOpacity ?? 1.0,
      minExtent: minExtent ?? currentExtent,
      maxExtent: maxExtent ?? currentExtent,
      currentExtent: currentExtent,
      child: child,
    );
  }

  @override
  _FlexibleSpaceBarState createState() => _FlexibleSpaceBarState();
}

class _FlexibleSpaceBarState extends State<DIYFlexibleSpaceBar> {
  bool _getEffectiveCenterTitle(ThemeData theme) {
    if (widget.centerTitle != null) return widget.centerTitle;
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
    }
    return null;
  }

  Alignment _getTitleAlignment(bool effectiveCenterTitle) {
    if (effectiveCenterTitle) return Alignment.bottomCenter;
    final TextDirection textDirection = Directionality.of(context);
    assert(textDirection != null);
    switch (textDirection) {
      case TextDirection.rtl:
        return Alignment.bottomRight;
      case TextDirection.ltr:
        return Alignment.bottomLeft;
    }
    return null;
  }

  double _getCollapsePadding(double t, FlexibleSpaceBarSettings settings) {
    switch (widget.collapseMode) {
      case CollapseMode.pin:
        return -(settings.maxExtent - settings.currentExtent);
      case CollapseMode.none:
        return 0.0;
      case CollapseMode.parallax:
        final double deltaExtent = settings.maxExtent - settings.minExtent;
        return -Tween<double>(begin: 0.0, end: deltaExtent / 4.0).transform(t);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final FlexibleSpaceBarSettings settings = context
          .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
      assert(
        settings != null,
        'A DIYFlexibleSpaceBar must be wrapped in the widget returned by DIYFlexibleSpaceBar.createSettings().',
      );

      final List<Widget> children = <Widget>[];

      final double deltaExtent = settings.maxExtent - settings.minExtent;

      // 0.0 -> Expanded
      // 1.0 -> Collapsed to toolbar
      final double t =
          (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
              .clamp(0.0, 1.0) as double;

      // background
      if (widget.background != null) {
        final double fadeStart =
            math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const double fadeEnd = 1.0;
        assert(fadeStart <= fadeEnd);

        /// do:反向设置背景透明度 实现
        ///DIY 背景透明度
        final double opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
        final double opacity2 = Interval(fadeStart, fadeEnd).transform(t);
        if (opacity > 0.0) {
          double height = settings.maxExtent;

          // StretchMode.zoomBackground
          if (widget.stretchModes.contains(StretchMode.zoomBackground) &&
              constraints.maxHeight > height) {
            height = constraints.maxHeight;
          }

          children.add(Positioned(
            top: _getCollapsePadding(t, settings),
            left: 0.0,
            right: 0.0,
            height: height,
            child: Opacity(
              opacity: opacity,
              child: widget.background,
            ),
          ));

          // StretchMode.blurBackground
          if (widget.stretchModes.contains(StretchMode.blurBackground) &&
              constraints.maxHeight > settings.maxExtent) {
            final double blurAmount =
                (constraints.maxHeight - settings.maxExtent) / 10;
            children.add(Positioned.fill(
                child: BackdropFilter(
                    child: Container(
                      color: Colors.transparent,
                    ),
                    filter: ui.ImageFilter.blur(
                      sigmaX: blurAmount,
                      sigmaY: blurAmount,
                    ))));
          }
        }
        //DIY  tabbar上滑后的背景色渐变效果
        double height = settings.maxExtent;
        PageController pageController = widget.pageController;
        children.add(Positioned(
          top: _getCollapsePadding(t, settings),
          left: 0.0,
          right: 0.0,
          height: height,
          child: Opacity(
            opacity: opacity2,
            child: AnimatedBuilder(
              animation: pageController,
              builder: (context, widget) {
                double page = 0;
                int realPage = 0;
                if (pageController.hasClients) {
                  page = pageController?.page ?? 0;
                  realPage = pageController?.page?.floor() ?? 0;
                } else {
                  page = pageController?.initialPage?.toDouble() ?? 0;
                  realPage = pageController?.initialPage ?? 0;
                }
                double opacity = 1 - (page - realPage).abs();
                Widget child = Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: opacity,
                      child: Container(
                        width: constraints.maxWidth,
                        height: height,
                        color: Common.colors[realPage],
                      ),
                    ),
                    Opacity(
                      opacity: 1 - opacity,
                      child: Container(
                        width: constraints.maxWidth,
                        height: height,
                        color: Common.colors[realPage + 1],
                      ),
                    ),
                  ],
                );
                return child;
              },
            ),
          ),
        ));
      }

      // title
      if (widget.title != null) {
        final ThemeData theme = Theme.of(context);

        Widget title;
        switch (theme.platform) {
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            title = widget.title;
            break;
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            title = Semantics(
              namesRoute: true,
              child: widget.title,
            );
            break;
        }

        // StretchMode.fadeTitle
        if (widget.stretchModes.contains(StretchMode.fadeTitle) &&
            constraints.maxHeight > settings.maxExtent) {
          final double stretchOpacity = 1 -
              (((constraints.maxHeight - settings.maxExtent) / 100)
                  .clamp(0.0, 1.0) as double);
          title = Opacity(
            opacity: stretchOpacity,
            child: title,
          );
        }

        final double opacity = settings.toolbarOpacity;
        if (opacity > 0.0) {
          TextStyle titleStyle = theme.primaryTextTheme.headline6;
          titleStyle =
              titleStyle.copyWith(color: titleStyle.color.withOpacity(opacity));
          final bool effectiveCenterTitle = _getEffectiveCenterTitle(theme);
          final EdgeInsetsGeometry padding = widget.titlePadding ??
              EdgeInsetsDirectional.only(
                start: effectiveCenterTitle ? 0.0 : 72.0,
                bottom: 16.0,
              );
          final double scaleValue =
              Tween<double>(begin: 1.5, end: 1.0).transform(t);
          final Matrix4 scaleTransform = Matrix4.identity()
            ..scale(scaleValue, scaleValue, 1.0);
          final Alignment titleAlignment =
              _getTitleAlignment(effectiveCenterTitle);
          children.add(Container(
            padding: padding,
            child: Transform(
              alignment: titleAlignment,
              transform: scaleTransform,
              child: Align(
                alignment: titleAlignment,
                child: DefaultTextStyle(
                  style: titleStyle,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      width: constraints.maxWidth / scaleValue,
                      alignment: titleAlignment,
                      child: title,
                    );
                  }),
                ),
              ),
            ),
          ));
        }
      }

      return ClipRect(child: Stack(children: children));
    });
  }
}

/// DIYTopHeaderAdapter配合NestedScrollView使用设置顶部背景组件跟随上滑同时上移
///
class DIYTopHeaderAdapter extends StatefulWidget {
  const DIYTopHeaderAdapter({
    Key key,
    @required this.child,
    @required this.header,
  })  : assert(child != null),
        assert(header != null),
        super(key: key);

  final Widget child;

  final Widget header;

  @override
  DIYTopHeaderAdapterState createState() => DIYTopHeaderAdapterState();
}

class DIYTopHeaderAdapterState extends State<DIYTopHeaderAdapter> {
  double offset = 0;

  bool _handleScrollNotification(ScrollNotification notification) {
    NestedScrollViewState state =
        notification.context.findAncestorStateOfType<NestedScrollViewState>();
    if (state != null) {
      double offset = state.outerController.offset;
      if (offset != this.offset) {
        this.offset = offset;
        setState(() {});
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: widget.child,
    );

    return Stack(
      children: <Widget>[
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: Transform.translate(
            offset: Offset(0, -offset),
            child: widget.header,
          ),
        ),
        child,
      ],
    );
  }
}

///
/// NOTICE::
///
/// In order to make package smaller,currently we're not supporting any build-in page transformers
/// You can find build in transforms here:
///
///
///

const int kMaxValue = 2000000000;
const int kMiddleValue = 1000000000;

///  Default auto play transition duration (in millisecond)
const int kDefaultTransactionDuration = 300;

class TransformInfo {
  /// The `width` of the `TransformerPageView`
  final double width;

  /// The `height` of the `TransformerPageView`
  final double height;

  /// The `position` of the widget pass to [PageTransformer.transform]
  ///  A `position` describes how visible the widget is.
  ///  The widget in the center of the screen' which is  full visible, position is 0.0.
  ///  The widge in the left ,may be hidden, of the screen's position is less than 0.0, -1.0 when out of the screen.
  ///  The widge in the right ,may be hidden, of the screen's position is greater than 0.0,  1.0 when out of the screen
  ///
  ///
  final double position;

  /// The `index` of the widget pass to [PageTransformer.transform]
  final int index;

  /// The `activeIndex` of the PageView
  final int activeIndex;

  /// The `activeIndex` of the PageView, from user start to swipe
  /// It will change when user end drag
  final int fromIndex;

  /// Next `index` is greater than this `index`
  final bool forward;

  /// User drag is done.
  final bool done;

  /// Same as [TransformerPageView.viewportFraction]
  final double viewportFraction;

  /// Copy from [TransformerPageView.scrollDirection]
  final Axis scrollDirection;

  TransformInfo(
      {this.index,
      this.position,
      this.width,
      this.height,
      this.activeIndex,
      this.fromIndex,
      this.forward,
      this.done,
      this.viewportFraction,
      this.scrollDirection});
  @override
  String toString() {
    return "------------TransformInfo--------------\n"
        "index $index \n"
        "position $position \n"
//        "width $width \n"
//        "height $height \n"
        "activeIndex $activeIndex \n"
        "fromIndex $fromIndex \n"
        "forward $forward \n"
        "done $done \n"
        "viewportFraction $viewportFraction \n";
  }
}

abstract class PageTransformer {
  ///
  final bool reverse;

  PageTransformer({this.reverse: false});

  /// Return a transformed widget, based on child and TransformInfo
  Widget transform(Widget child, TransformInfo info);
}

typedef Widget PageTransformerBuilderCallback(Widget child, TransformInfo info);

class PageTransformerBuilder extends PageTransformer {
  final PageTransformerBuilderCallback builder;

  PageTransformerBuilder({bool reverse: false, @required this.builder})
      : assert(builder != null),
        super(reverse: reverse);

  @override
  Widget transform(Widget child, TransformInfo info) {
    return builder(child, info);
  }
}

class TransformerPageController extends PageController {
  final int itemCount;
  final bool reverse;

  TransformerPageController({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
    this.itemCount,
    this.reverse: false,
  }) : super(
            initialPage: TransformerPageController._getRealIndexFromRenderIndex(
                initialPage ?? 0, itemCount, reverse),
            keepPage: keepPage,
            viewportFraction: viewportFraction);

  int getRenderIndexFromRealIndex(num index) {
    return _getRenderIndexFromRealIndex(index, itemCount, reverse);
  }

  int getRealItemCount() {
    if (itemCount == 0) return 0;
    return itemCount;
  }

  static _getRenderIndexFromRealIndex(num index, int itemCount, bool reverse) {
    if (itemCount == 0) return 0;
    int renderIndex;
    renderIndex = index;
    if (reverse) {
      renderIndex = itemCount - renderIndex - 1;
    }

    return renderIndex;
  }

  double get realPage {
    double page;
    if (position.maxScrollExtent == null || position.minScrollExtent == null) {
      page = 0.0;
    } else {
      page = super.page;
    }

    return page;
  }


  double get page {
    return realPage;
  }

  int getRealIndexFromRenderIndex(num index) {
    return _getRealIndexFromRenderIndex(index, itemCount, reverse);
  }

  static int _getRealIndexFromRenderIndex(
      num index, int itemCount, bool reverse) {
    int result = reverse ? (itemCount - index - 1) : index;
    return result;
  }
}


/// 当首页Tab切换或是PageView滑动时
/// DIYTopHeaderAdapter的header组件背景页面切换动效
class TransformerPageView extends StatefulWidget {
  /// Create a `transformed` widget base on the widget that has been passed to  the [PageTransformer.transform].
  /// See [TransformInfo]
  ///
  final PageTransformer transformer;

  /// Same as [PageView.scrollDirection]
  ///
  /// Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// Same as [PageView.physics]
  final ScrollPhysics physics;

  /// Set to false to disable page snapping, useful for custom scroll behavior.
  /// Same as [PageView.pageSnapping]
  final bool pageSnapping;

  /// Called whenever the page in the center of the viewport changes.
  /// Same as [PageView.onPageChanged]
  final ValueChanged<int> onPageChanged;

  final IndexedWidgetBuilder itemBuilder;

  final TabController controller;


  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  final TransformerPageController pageController;

  /// Set true to open infinity loop mode.
  final bool loop;

  /// This value is only valid when `pageController` is not set,
  final int itemCount;

  /// This value is only valid when `pageController` is not set,
  final double viewportFraction;

  /// If not set, it is controlled by this widget.
  final int index;

  /// Creates a scrollable list that works page by page using widgets that are
  /// created on demand.
  ///
  /// This constructor is appropriate for page views with a large (or infinite)
  /// number of children because the builder is called only for those children
  /// that are actually visible.
  ///
  /// Providing a non-null [itemCount] lets the [PageView] compute the maximum
  /// scroll extent.
  ///
  /// [itemBuilder] will be called only with indices greater than or equal to
  /// zero and less than [itemCount].
  TransformerPageView({
    Key key,
    this.index,
    Duration duration,
    this.curve: Curves.ease,
    this.viewportFraction: 1.0,
    this.loop: false,
    this.scrollDirection = Axis.horizontal,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    this.controller,
    this.transformer,
    this.itemBuilder,
    this.pageController,
    @required this.itemCount,
  })  : assert(itemCount != null),
        assert(itemCount == 0 || itemBuilder != null || transformer != null),
        this.duration =
            duration ?? Duration(milliseconds: kDefaultTransactionDuration),
        super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _TransformerPageViewState();
  }

  static int getRealIndexFromRenderIndex(
      {bool reverse, int index, int itemCount, bool loop}) {
    int initPage = reverse ? (itemCount - index - 1) : index;
    if (loop) {
      initPage += kMiddleValue;
    }
    return initPage;
  }

  static PageController createPageController(
      {bool reverse,
      int index,
      int itemCount,
      bool loop,
      double viewportFraction}) {
    return PageController(
        initialPage: getRealIndexFromRenderIndex(
            reverse: reverse, index: index, itemCount: itemCount, loop: loop),
        viewportFraction: viewportFraction);
  }
}

class _TransformerPageViewState extends State<TransformerPageView> {
  Size _size;
  int _activeIndex;
  double _currentPixels;
  bool _done = false;

  ///This value will not change until user end drag.
  int _fromIndex;

  PageTransformer _transformer;

  TransformerPageController _pageController;

  Widget _buildItemNormal(BuildContext context, int index) {
    int renderIndex = _pageController.getRenderIndexFromRealIndex(index);
    Widget child = widget.itemBuilder(context, renderIndex);
    return child;
  }

  Widget _buildItem(BuildContext context, int index) {
    return AnimatedBuilder(
        animation: _pageController,
        builder: (BuildContext c, Widget w) {
          int renderIndex = _pageController.getRenderIndexFromRealIndex(index);
          Widget child;
          if (widget.itemBuilder != null) {
            child = widget.itemBuilder(context, renderIndex);
          }
          if (child == null) {
            child = Container();
          }
          if (_size == null) {
            return child ?? Container();
          }

          double position;

          double page = _pageController.realPage;

          if (_transformer.reverse) {
            position = page - index;
          } else {
            position = index - page;
          }
          position *= widget.viewportFraction;

          TransformInfo info = TransformInfo(
              index: renderIndex,
              width: _size.width,
              height: _size.height,
              position: position.clamp(-1.0, 1.0),
              activeIndex:
                  _pageController.getRenderIndexFromRealIndex(_activeIndex),
              fromIndex: _fromIndex,
              forward: _pageController.position.pixels - _currentPixels >= 0,
              done: _done,
              scrollDirection: widget.scrollDirection,
              viewportFraction: widget.viewportFraction);
          return _transformer.transform(child, info);
        });
  }

  double _calcCurrentPixels() {
    _currentPixels = _pageController.getRenderIndexFromRealIndex(_activeIndex) *
        _pageController.position.viewportDimension *
        widget.viewportFraction;
    return _currentPixels;
  }

  @override
  Widget build(BuildContext context) {
    IndexedWidgetBuilder builder =
        _transformer == null ? _buildItemNormal : _buildItem;
    Widget child = PageView.builder(
      itemBuilder: builder,
      itemCount: _pageController.getRealItemCount(),
      onPageChanged: _onIndexChanged,
      controller: _pageController,
      scrollDirection: widget.scrollDirection,
      physics: widget.physics,
      pageSnapping: widget.pageSnapping,
      reverse: _pageController.reverse,
    );
    if (_transformer == null) {
      return child;
    }
    return NotificationListener(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollStartNotification) {
            _calcCurrentPixels();
            _done = false;
            _fromIndex = _activeIndex;
          } else if (notification is ScrollEndNotification) {
            _calcCurrentPixels();
            _fromIndex = _activeIndex;
            _done = true;
          }

          return false;
        },
        child: child);
  }

  void _onIndexChanged(int index) {
    _activeIndex = index;
    if (widget.onPageChanged != null) {
      widget.onPageChanged(_pageController.getRenderIndexFromRealIndex(index));
    }
  }

  void _onGetSize(_) {
    Size size;
    if (context == null) {
      onGetSize(size);
      return;
    }
    RenderObject renderObject = context.findRenderObject();
    if (renderObject != null) {
      Rect bounds = renderObject.paintBounds;
      if (bounds != null) {
        size = bounds.size;
      }
    }
    _calcCurrentPixels();
    onGetSize(size);
  }

  void onGetSize(Size size) {
    if (mounted) {
      setState(() {
        _size = size;
      });
    }
  }

  @override
  void initState() {
    _transformer = widget.transformer;
    //  int index = widget.index ?? 0;
    _pageController = widget.pageController;
    if (_pageController == null) {
      _pageController = TransformerPageController(
          initialPage: widget.index,
          itemCount: widget.itemCount,
          reverse:
              widget.transformer == null ? false : widget.transformer.reverse);
    }
    _fromIndex = _activeIndex = _pageController.initialPage;

    _controller = getNotifier();
    if (_controller != null) {
      _controller.addListener(onChangeNotifier);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(TransformerPageView oldWidget) {
    _transformer = widget.transformer;
    int index = widget.index ?? 0;
    bool created = false;
    if (_pageController != widget.pageController) {
      if (widget.pageController != null) {
        _pageController = widget.pageController;
      } else {
        created = true;
        _pageController = TransformerPageController(
            initialPage: widget.index,
            itemCount: widget.itemCount,
            reverse: widget.transformer == null
                ? false
                : widget.transformer.reverse);
      }
    }

    if (_pageController.getRenderIndexFromRealIndex(_activeIndex) != index) {
      _fromIndex = _activeIndex = _pageController.initialPage;
      if (!created) {
        int initPage = _pageController.getRealIndexFromRenderIndex(index);
        _pageController.animateToPage(initPage,
            duration: widget.duration, curve: widget.curve);
      }
    }
    if (_transformer != null)
      WidgetsBinding.instance.addPostFrameCallback(_onGetSize);

    if (_controller != getNotifier()) {
      if (_controller != null) {
        _controller.removeListener(onChangeNotifier);
      }
      _controller = getNotifier();
      if (_controller != null) {
        _controller.addListener(onChangeNotifier);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    if (_transformer != null)
      WidgetsBinding.instance.addPostFrameCallback(_onGetSize);
    super.didChangeDependencies();
  }

  ChangeNotifier getNotifier() {
    return widget.controller;
  }

  void onChangeNotifier() {
    int index;
    index = _pageController
        .getRealIndexFromRenderIndex(widget.controller.index);
      _pageController
          .animateToPage(index,
              duration: widget.duration, curve: widget.curve ?? Curves.ease);
//    } else {
//      _pageController.jumpToPage(index);
//    }
  }

  ChangeNotifier _controller;

  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.removeListener(onChangeNotifier);
    }
  }
}

class IndexController extends ChangeNotifier {
  static const int NEXT = 1;
  static const int PREVIOUS = -1;
  static const int MOVE = 0;

  Completer _completer;

  int index;
  bool animation;
  int event;

  Future move(int index, {bool animation: true}) {
    this.animation = animation ?? true;
    this.index = index;
    this.event = MOVE;
    _completer = Completer();
    notifyListeners();
    return _completer.future;
  }

  Future next({bool animation: true}) {
    this.event = NEXT;
    this.animation = animation ?? true;
    _completer = Completer();
    notifyListeners();
    return _completer.future;
  }

  Future previous({bool animation: true}) {
    this.event = PREVIOUS;
    this.animation = animation ?? true;
    _completer = Completer();
    notifyListeners();
    return _completer.future;
  }

  void complete() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }
}






class ParallaxColor extends StatefulWidget {
  final Widget child;

  final List<Color> colors;

  final TransformInfo info;

  ParallaxColor({
    @required this.colors,
    @required this.info,
    @required this.child,
  });

  @override
  State<StatefulWidget> createState() {
    return new _ParallaxColorState();
  }
}

class _ParallaxColorState extends State<ParallaxColor> {
  Paint paint = new Paint();

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      painter: new ColorPainter(paint, widget.info, widget.colors),
      child: widget.child,
    );
  }
}

typedef void PaintCallback(Canvas canvas, Size siz);

class ColorPainter extends CustomPainter {
  final Paint _paint;
  final TransformInfo info;
  final List<Color> colors;

  ColorPainter(this._paint, this.info, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    int index = info.fromIndex;
    _paint.color = colors[index];
    canvas.drawRect(
        new Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
    if (info.done) {
      return;
    }
    int alpha;
    int color;
    double opacity;
    double position = info.position;
    if (info.forward) {
      if (index < colors.length - 1) {
        color = colors[index + 1].value & 0x00ffffff;
        opacity = (position <= 0
            ? (-position / info.viewportFraction)
            : 1 - position / info.viewportFraction);
        if (opacity > 1) {
          opacity -= 1.0;
        }
        if (opacity < 0) {
          opacity += 1.0;
        }
//        if(index == 0){
//          print("paint $opacity");
//        }

        alpha = (0xff * opacity).toInt();
        _paint.color = new Color((alpha << 24) | color);
        canvas.drawRect(
            new Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
      }
    } else {
      if (index > 0) {
        color = colors[index - 1].value & 0x00ffffff;
        opacity = (position > 0
            ? position / info.viewportFraction
            : (1 + position / info.viewportFraction));
        if (opacity > 1) {
          opacity -= 1.0;
        }
        if (opacity < 0) {
          opacity += 1.0;
        }
        alpha = (0xff * opacity).toInt();

        _paint.color = new Color((alpha << 24) | color);
        canvas.drawRect(
            new Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
      }
    }
  }

  @override
  bool shouldRepaint(ColorPainter oldDelegate) {
    return oldDelegate.info != info;
  }
}



class ParallaxContainer extends StatelessWidget {
  final Widget child;
  final double position;
  final double translationFactor;
  final double opacityFactor;

  ParallaxContainer(
      {@required this.child,
        @required this.position,
        this.translationFactor: 100.0,
        this.opacityFactor: 1.0})
      : assert(position != null),
        assert(translationFactor != null);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (1 - position.abs()).clamp(0.0, 1.0) * opacityFactor,
      child: new Transform.translate(
        offset: new Offset(position * translationFactor, 0.0),
        child: child,
      ),
    );
  }
}

class ParallaxImage extends StatelessWidget {
  final Image image;
  final double imageFactor;

  ParallaxImage.asset(String name, {double position, this.imageFactor: 0.3})
      : assert(imageFactor != null),
        image = Image.asset(name,
            fit: BoxFit.cover,
            alignment: FractionalOffset(
              0.5 + position * imageFactor,
              0.5,
            ));

  @override
  Widget build(BuildContext context) {
    return image;
  }
}

