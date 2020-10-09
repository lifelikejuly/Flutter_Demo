import 'package:flutter/material.dart';
import 'package:flutter_demo/demo/tabbar/custom_tab.dart';
import 'package:flutter_demo/demo/tabbar/underLineIndicator.dart';

import 'no_tabbar.dart';

class TabBarDemo2 extends StatefulWidget {
  @override
  _TabBarDemo1State createState() => _TabBarDemo1State();
}

class _TabBarDemo1State extends State<TabBarDemo2>
    with SingleTickerProviderStateMixin {
  List<String> tabs = [
    "皮球",
    "篮球",
    "西瓜",
    "玻璃",
    "芒果",
    "西红柿",
    "土豆",
  ];

  List<Widget> tabWidgets;
  List<Widget> tabPageViews;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabWidgets = List();
    tabPageViews = List();
    tabs.forEach((element) {
      tabWidgets.add(
        Container(
          width: 30,
          alignment: Alignment.bottomLeft,
          child: Text(
            element,
            style: TextStyle(color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
      tabPageViews.add(
        CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text(element),
                    Text(element),
                    Text(element),
                    Text(element),
                    Text(element),
                    Container(
                      height: 200,
                      color: Colors.brown,
                    ),
                    Text(element),
                    Text(element),
                    Text(element),
                    Text(element),
                    Text(element),
                    Text(element),
                    Container(
                      height: 200,
                      color: Colors.orange,
                    ),
                    Text(element),
                    Text(element),
                    Text(element),
                    Text(element),
                    Text(element),
                    Text(element),
                    Text(element),
                    Text(element),
                    Container(
                      height: 200,
                      color: Colors.deepOrange,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
    tabController = TabController(
      initialIndex: 0,
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Column(
      children: <Widget>[
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: tabPageViews,
          ),
        )
      ],
    );
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                title: Text("Title"),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: PreferredSize(
                    child: AppBar(
                      titleSpacing: 0.0,
                      automaticallyImplyLeading: false,
                      title: Container(
                        color: Colors.red,
                      ),
                    ),
                    preferredSize: Size.fromHeight(155),
                  ),
                ),
                expandedHeight: 200,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: NoGradientTabBar(
//                    indicator: UnderlineTabIndicatorX(),
                    isScrollable: true,
                    tabs: tabWidgets,
                    unselectedLabelStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    controller: tabController,
                  ),
                ),
              )
            ];
          },
          body: body),
    );
  }


}


class UnderlineTabIndicatorX extends Decoration {
  /// Create an underline style selected tab indicator.
  ///
  /// The [borderSide] and [insets] arguments must not be null.
  const UnderlineTabIndicatorX({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
  }) : assert(borderSide != null),
        assert(insets != null);

  /// The color and weight of the horizontal line drawn below the selected tab.
  final BorderSide borderSide;

  /// Locates the selected tab's underline relative to the tab's boundary.
  ///
  /// The [TabBar.indicatorSize] property can be used to define the
  /// tab indicator's bounds in terms of its (centered) tab widget with
  /// [TabIndicatorSize.label], or the entire tab with [TabIndicatorSize.tab].
  final EdgeInsetsGeometry insets;

  @override
  Decoration lerpFrom(Decoration a, double t) {
    if (a is UnderlineTabIndicator) {
      return UnderlineTabIndicatorX(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration lerpTo(Decoration b, double t) {
    if (b is UnderlineTabIndicator) {
      return UnderlineTabIndicatorX(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _UnderlinePainter createBoxPainter([ VoidCallback onChanged ]) {
    return _UnderlinePainter(this, onChanged);
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final UnderlineTabIndicatorX decoration;

  BorderSide get borderSide => decoration.borderSide;
  EdgeInsetsGeometry get insets => decoration.insets;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    return Rect.fromLTWH(
      indicator.left,
      indicator.bottom - borderSide.width,
      indicator.width,
      borderSide.width,
    );
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size;
    final TextDirection textDirection = configuration.textDirection;
    final Rect indicator = _indicatorRectFor(rect, textDirection).deflate(borderSide.width / 2.0);
    final Paint paint = borderSide.toPaint()..strokeCap = StrokeCap.square;
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }
}
