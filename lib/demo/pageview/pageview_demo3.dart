import 'package:flutter/material.dart';


import 'dart:math';

class PageViewDemo3 extends StatefulWidget {
  PageViewDemo3({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PageViewDemo3> {
  final PageController _controller = PageController();
  final ScrollController _scrollController = ScrollController();
  var pageOffset = 0.0;
  var screenWidth = 0.0;

  var images = [
    'http://via.placeholder.com/350x150',
    'http://0rz.tw/RTyOI',
    'http://0rz.tw/GZfs8',
    'http://0rz.tw/myTYd',
    'http://0rz.tw/HuKP2'
  ];

  var texts = ['GOW 1', 'GOW 2', 'GOW 3', 'GEARS OF WAR JUDGMENT', 'GEARS OF WAR:ULTIMATE EDITION'];

  void _offsetChanged() {
    // 每次的移動都重新計算對應的偏移值與特效
    setState(() {
      pageOffset = _controller.offset / screenWidth;
      // 利用 PageController.offset 來移動
      _scrollController.jumpTo(_controller.offset);
    });

    print(
        "offset: from ${_controller.initialScrollOffset}, to ${_controller.offset}");
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // 監聽 PageController 的 Scroller 變化
    _controller.addListener(_offsetChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 預設使用螢幕的寬度
    print("page width: ${MediaQuery.of(context).size.width}");
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("sss"),
        ),
        body: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            PageView.builder(
              controller: _controller,
              itemCount:100,
              itemBuilder: (context, index) {
                // 計算每次異動時左邊的 Page 是哪個 index
                var currentLeftPageIndex = pageOffset.floor();
                // 計算現在畫面 Offset 佔的比例
                var currentPageOffsetPercent =
                    pageOffset - currentLeftPageIndex;
                // 加入移動的特效
                return Transform.translate(
                  // 因爲是水平滑動，所以設定 offset 的 X 值，因爲 Page 固定不動，所以要先用 pageOffset 減去 index 得到 負數
                  // 如果是垂直滑動，請設定 offset 的 Y 值
                  offset: Offset((pageOffset - index) * screenWidth, 0),
                  child: Opacity(
                    // 如果現在左邊的 index 等於正要建立的 index，則讓它透明度變淡，因爲它要退出畫面了
                    // 相反地是要顯示，則使用原本的 currentPageOffsetPercent
                    opacity: currentLeftPageIndex == index
                        ? 1 - currentPageOffsetPercent
                        : currentPageOffsetPercent,
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage("http://via.placeholder.com/350x150"),
                                fit: BoxFit.cover))),
                  ),
                );
              },
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: DotsIndicator(
                  color: Colors.white,
                  itemCount: images.length,
                  controller: _controller,
                )),
            // 利用 IgnorePointer 忽略 ListView 的滑動
            IgnorePointer(
                child: ListView.builder(
                  // 改利用 ScrollController 來操作 ListView
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: texts.length,
                  itemBuilder: (context, index) {
                    return Container(
                        alignment: Alignment.bottomLeft,
                        // 設定 width 與 Page 一致
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 10, bottom: 50),
                        child: Text(
                          texts[index],
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ));
                  },
                ))
          ],
        ));
  }
}

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Material(
        color: color,
        type: MaterialType.circle,
        child: new Container(
          width: _kDotSize * zoom,
          height: _kDotSize * zoom,
          child: new InkWell(
            onTap: () => onPageSelected(index),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
