import 'package:flutter/material.dart';

import 'underLineIndicator.dart';

class TabbarDemo3 extends StatefulWidget {
  @override
  _TabbarDemo3State createState() => _TabbarDemo3State();
}

class _TabbarDemo3State extends State<TabbarDemo3>
    with SingleTickerProviderStateMixin {
  List<String> tabs = [
    "关注",
    "发现",
    "明星饭圈",
    "寻味指南",
    "史莱姆",
    "妈咪宝贝",
    "汉服同袍",
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
        TabKK(
//          child: Container(
//            padding: EdgeInsets.symmetric(horizontal: 12),
//            child: Text(
//              element,
//              style: TextStyle(
//                color: Colors.black,
//                fontSize: 15,
//              ),
//              textAlign: TextAlign.left,
//              maxLines: 1,
//              overflow: TextOverflow.ellipsis,
//            ),
//          ),
          text: element,
        ),
      );
      tabPageViews.add(Container(
        child: Center(
          child: Text(element),
        ),
      ));
    });
    tabController = TabController(
      initialIndex: 0,
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            height: 42,
            width: MediaQuery.of(context).size.width,
            child: TabBar(
              indicator: UnderLineIndicator(
                borderSide: BorderSide(color: Color(0xFFFF1F50), width: 3),
                insets: EdgeInsets.only(bottom: 2),
                width: 25,
              ),
              controller: tabController,
              isScrollable: true,
              labelColor: Color(0xFF333333),
              unselectedLabelColor: Color(0xFF333333),
              labelPadding: EdgeInsets.all(0),
              unselectedLabelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF333333),
              ),
              labelStyle: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: tabWidgets,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: tabPageViews,
            ),
          )
        ],
      ),
    );
  }
}

class TabKK extends StatelessWidget {
  /// Creates a material design [TabBar] tab.
  ///
  /// At least one of [text], [icon], and [child] must be non-null. The [text]
  /// and [child] arguments must not be used at the same time. The
  /// [iconMargin] is only useful when [icon] and either one of [text] or
  /// [child] is non-null.
  const TabKK({
    Key key,
    this.text,
    this.icon,
    this.iconMargin = const EdgeInsets.only(bottom: 10.0),
    this.child,
  })  : assert(text != null || child != null || icon != null),
        assert(!(text != null && null != child)),
        // TODO(goderbauer): https://github.com/dart-lang/sdk/issues/34180
        super(key: key);

  /// The text to display as the tab's label.
  ///
  /// Must not be used in combination with [child].
  final String text;

  /// The widget to be used as the tab's label.
  ///
  /// Usually a [Text] widget, possibly wrapped in a [Semantics] widget.
  ///
  /// Must not be used in combination with [text].
  final Widget child;

  /// An icon to display as the tab's label.
  final Widget icon;

  /// The margin added around the tab's icon.
  ///
  /// Only useful when used in combination with [icon], and either one of
  /// [text] or [child] is non-null.
  final EdgeInsetsGeometry iconMargin;

  Widget _buildLabelText() {
    return child ??
        Text(
          text,
          softWrap: false,
          overflow: TextOverflow.fade,
          textWidthBasis: TextWidthBasis.parent,
          textAlign: TextAlign.justify,
        );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    double height;
    Widget label;
    height = 50;
//    label = Column(
//      children: <Widget>[
//        _buildLabelText(),
//      ],
//    );

    label = Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: _buildLabelText(),
    );

//    return SizedBox(
//      height: height,
//      child: Center(
//        child: label,
//        widthFactor: 1.0,
//      ),
//    );

    return label;
  }
}

/**
    print("-------------------------------------\n"
    "listenerScrollOffset depth ${position.depth}\n"
    "axis ${position.metrics.axis.toString()}\n"
    "pixels ${position.metrics.pixels}\n"
    "axisDirection ${position.metrics.axisDirection}\n"
    "atEdge ${position.metrics.atEdge}\n"
    "minScrollExtent ${position.metrics.minScrollExtent}\n"
    "maxScrollExtent ${position.metrics.maxScrollExtent}\n"
    "extentAfter ${position.metrics.extentAfter}\n"
    "extentBefore ${position.metrics.extentBefore}\n"
    "viewportDimension ${position.metrics.viewportDimension}\n"
    "extentInside ${position.metrics.extentInside}\n"
    "runtimeType ${position.runtimeType}\n"
    "----------------------------------");
 */

//说明：
//NestedScrollView 与body 中的CustomScrollView滑动冲突解决，通过CustomScrollView的_controller2
//控制NestedScrollView的_controller，以达到控制NestedScrollView的滚动的结果，当内部的CustomScrollView滚动时候_controller2监听器里 _controller.jumpTo(_controller2.offset),实现外层的NestedScrollView滚动
