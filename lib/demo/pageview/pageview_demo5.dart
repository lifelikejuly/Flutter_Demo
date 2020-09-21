import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageViewDemo5 extends StatefulWidget {
  @override
  _PageViewDemo5State createState() => _PageViewDemo5State();
}

class _PageViewDemo5State extends State<PageViewDemo5> {
  ScrollController scrollController;

  double _bookWidth = 100;
  int _currentPage = 0;
  double offset = 0;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      offset = scrollController.offset;
      double test = offset / (_bookWidth);
      int next = test.floor();
      if (next < 0) {
        next = 0;
      }
      if (_currentPage != next) {
        _currentPage = next;
      }
      setState(() {});
      print("ScrollController $_currentPage");
    });
  }

  double _calScale(int currentPosition, int thisPosition, double pre) {
    if (thisPosition == currentPosition) {
      return 1 - pre / 10;
    } else if (thisPosition == currentPosition + 1) {
      return 9 / 10 + pre / 10;
    } else {
      return 9 / 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(left: 0),
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: 1000,
          itemBuilder: (context, index) {
            double width = _bookWidth;
            var pre = 0.0;
            if (_currentPage == index) {
              pre = (offset - _bookWidth * index) / _bookWidth;
              if (pre < 0) {
                pre = -pre;
              }
            } else if (_currentPage == index - 1) {
              pre = 1 - (index * _bookWidth - offset) / _bookWidth;
              if (pre < 0) {
                pre = -pre;
              }
            } else {
              pre = 0;
            }
            return Container(
              width: _bookWidth,
              height: 300,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: 0,
                    child:Transform.scale(
                      scale: _calScale(_currentPage, index, pre),
                      child: Container(
                        width: width - 20,
                        height: 1.38 * width,
                        child: Center(
                          child: Text(
                            index.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          physics: PagingScrollPhysics2(
            itemDimension: _bookWidth,
            leadingSpacing: 0,
            maxSize: _bookWidth * 1000.0,
          ),
        ),
      ),
    );
  }
}

class PagingScrollPhysics2 extends ScrollPhysics {
  final double itemDimension; // ListView children item 固定宽度
  final double leadingSpacing; // 选中 item 离左边缘留白
  final double maxSize; // 最大可滑动区域

  PagingScrollPhysics2(
      {this.maxSize,
      this.leadingSpacing,
      this.itemDimension,
      ScrollPhysics parent})
      : super(parent: parent);

  @override
  PagingScrollPhysics2 applyTo(ScrollPhysics ancestor) {
    return PagingScrollPhysics2(
        maxSize: maxSize,
        itemDimension: itemDimension,
        leadingSpacing: leadingSpacing,
        parent: buildParent(ancestor));
  }

  double _getPage(ScrollPosition position, double leading) {
    return (position.pixels + leading) / itemDimension;
  }

  double _getPixels(double page, double leading) {
    return (page * itemDimension) - leading;
  }

  double _getTargetPixels(
    ScrollPosition position,
    Tolerance tolerance,
    double velocity,
    double leading,
  ) {
    double page = _getPage(position, leading);

    if (position.pixels < 0) {
      return 0.0;
    }

    if (position.pixels >= maxSize) {
      return maxSize;
    }

    if (position.pixels > 0) {
      if (velocity < -tolerance.velocity) {
        page -= 0.5;
      } else if (velocity > tolerance.velocity) {
        page += 0.5;
      }
      return _getPixels(page.roundToDouble(), leading);
    } else {
      return 0.0;
    }
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.

    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent))
      return super.createBallisticSimulation(position, velocity);

    final Tolerance tolerance = this.tolerance;

    final double target =
        _getTargetPixels(position, tolerance, velocity, leadingSpacing);
    if (target != position.pixels)
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
