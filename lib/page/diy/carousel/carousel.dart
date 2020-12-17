import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_demo/demo/pageview/paging_scroll_physics.dart';

typedef BannerOffsetListener = void Function(
    int pagePosition, double pageOffset);

class BubbleCarousel extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final double offsetWidth;
  final int offsetPre;
  final int length;
  final int kMiddleValue;
  final IndexedWidgetBuilder itemBuilder;
  final Duration duration;
  final BannerOffsetListener listener;

  BubbleCarousel({
    @required this.cardWidth,
    @required this.cardHeight,
    @required this.offsetWidth,
    @required this.length,
    @required this.itemBuilder,
    @required this.offsetPre,
    this.duration = const Duration(seconds: 4),
    this.kMiddleValue = 100,
    this.listener,
  })  : assert(offsetPre >= 0 && offsetPre <= 100),
        assert(length > 0);

  @override
  _BubbleCarouselState createState() => _BubbleCarouselState();
}

class _BubbleCarouselState extends State<BubbleCarousel> {
  int _pagePosition = 0;
  double pageOffset = 0;
  ScrollController pageScrollController;

  int get kMiddleValue => widget.kMiddleValue;

  int get length => widget.length;

  double get cardWidth => widget.cardWidth;

  double get cardHeight => widget.cardHeight;

  double get offsetWidth => widget.offsetWidth;

  IndexedWidgetBuilder get itemBuilder => widget.itemBuilder;

  BannerOffsetListener get listener => widget.listener;

  Duration get duration => widget.duration;

  int get offsetPre => widget.offsetPre;

  Timer _timer;

  _startTimer() {
    if (_timer != null) return;
    _timer = Timer.periodic(duration, (timer) {
      if ((pageScrollController?.hasClients ?? false) && mounted && length > 0) {
        double newOffset = pageScrollController.offset + cardWidth;
        if (newOffset < (kMiddleValue * length * cardWidth - 2 * cardWidth)) {
          pageScrollController?.animateTo(newOffset,
              duration: Duration(milliseconds: 500), curve: Curves.linear);
        } else {
          pageScrollController?.jumpTo(length * 4 * cardWidth);
        }
      }
    });
  }

  _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void initState() {
    super.initState();
    _pagePosition = 0;
    pageOffset = 0;
    if (length > 0) {
      // 初始化jump太大会卡死,如果设置itemExtent就有导致第一个卡片的padding失效，目前折中跳转4个
      _pagePosition = length * 4;
      pageOffset = _pagePosition * cardWidth;
//      _pagePosition = 0;
//      pageOffset = 0;
      pageScrollController = ScrollController(
          keepScrollOffset: false, initialScrollOffset: pageOffset);
      pageScrollController.addListener(() {
        pageOffset = pageScrollController.offset;
        double nowOffset = pageOffset / (cardWidth);
        int next = nowOffset.floor();
        if (next < 0) {
          next = 0;
        }
        if (_pagePosition != next) {
          _pagePosition = next;
        }
//        if (listener != null) {
//          listener(_pagePosition, pageOffset);
//        }
        if (mounted) setState(() {});
      });
      _startTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
    pageScrollController?.dispose();
    pageScrollController = null;
  }

  @override
  Widget build(BuildContext context) {
    if (length <= 0) return Container();
    Widget child = ListView.builder(
      itemBuilder: (context, index) {
        var pre = 0.0;
        if (_pagePosition == index) {
          pre = (pageOffset - cardWidth * index) / cardWidth;
          if (pre < 0) {
            pre = -pre;
          }
        } else if (_pagePosition == index - 1) {
          pre = 1 - (index * cardWidth - pageOffset) / cardWidth;
          if (pre < 0) {
            pre = -pre;
          }
        } else if (_pagePosition == index - 2) {
          pre = 2 - (index * cardWidth - pageOffset) / cardWidth;
          if (pre < 0) {
            pre = -pre;
          }
        }
        var scale = _calScale(_pagePosition, index, pre);
        var offset = _calScale3(_pagePosition, index, pre);
        return Container(
          height: cardHeight,
          width: cardWidth + (index == 0 ? 12 : 0),
          alignment: Alignment.topCenter,
          child: Transform.scale(
            origin: (_pagePosition + 2 == index || _pagePosition + 3 == index)
                ? Offset(offsetWidth * offset, 0)
                : _pagePosition - 1 == index
                ? Offset(-cardWidth / 2, 0)
                : Offset(0, 0),
            scale: scale,
            child: itemBuilder(context, index),
          ),
        );
      },
      itemCount: kMiddleValue * length,
      scrollDirection: Axis.horizontal,
      physics: PagingScrollPhysics(
          maxSize: kMiddleValue * length * cardWidth + 12,
          itemDimension: cardWidth,
          leadingSpacing: 0),
      controller: pageScrollController,
    );
    child = Listener(
      onPointerDown: (event) {
        _cancelTimer();
      },
      onPointerCancel: (event) {
        _startTimer();
      },
      onPointerUp: (event) {
        _startTimer();
      },
      child: child,
    );
    return child;
  }

  double _calScale(int currentPosition, int thisPosition, double pre) {
    if (thisPosition == currentPosition) {
      return (1 - pre * (100 - offsetPre) / 100);
    } else if (thisPosition == currentPosition + 1) {
      return (offsetPre / 100 + pre * (100 - offsetPre) / 100);
    } else {
      return (offsetPre / 100);
    }
  }

  double _calScale3(int currentPosition, int thisPosition, double pre) {
    if (thisPosition == currentPosition + 2) {
      return pre - 1;
    } else if (thisPosition == currentPosition + 3) {
      return -1;
    } else {
      return 0;
    }
  }
}


class StaticBubbleCarousel extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final double offsetWidth;
  final int offsetPre;
  final int length;
  final int kMiddleValue;
  final IndexedWidgetBuilder itemBuilder;
  final Duration duration;
  final BannerOffsetListener listener;

  StaticBubbleCarousel({
    @required this.cardWidth,
    @required this.cardHeight,
    @required this.offsetWidth,
    @required this.length,
    @required this.itemBuilder,
    @required this.offsetPre,
    this.duration = const Duration(seconds: 4),
    this.kMiddleValue = 100,
    this.listener,
  })  : assert(offsetPre >= 0 && offsetPre <= 100),
        assert(length > 0);

  @override
  _StaticBubbleCarouselState createState() => _StaticBubbleCarouselState();
}

class _StaticBubbleCarouselState extends State<StaticBubbleCarousel> {
  int _pagePosition = 0;
  double pageOffset = 0;
  ScrollController pageScrollController;

  int get kMiddleValue => widget.kMiddleValue;

  int get length => widget.length;

  double get cardWidth => widget.cardWidth;

  double get cardHeight => widget.cardHeight;

  double get offsetWidth => widget.offsetWidth;

  IndexedWidgetBuilder get itemBuilder => widget.itemBuilder;

  BannerOffsetListener get listener => widget.listener;

  Duration get duration => widget.duration;

  int get offsetPre => widget.offsetPre;

  Timer _timer;

  _startTimer() {
    if (_timer != null) return;
    _timer = Timer.periodic(duration, (timer) {
      if ((pageScrollController?.hasClients ?? false) && mounted && length > 0) {
        double newOffset = pageScrollController.offset + cardWidth;
        if (newOffset < (kMiddleValue * length * cardWidth - 2 * cardWidth)) {
          pageScrollController?.animateTo(newOffset,
              duration: Duration(milliseconds: 500), curve: Curves.linear);
        } else {
          pageScrollController?.jumpTo(length * 4 * cardWidth);
        }
      }
    });
  }

  _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void initState() {
    super.initState();
    _pagePosition = 0;
    pageOffset = 0;
    if (length > 0) {
      // 初始化jump太大会卡死,如果设置itemExtent就有导致第一个卡片的padding失效，目前折中跳转4个
      _pagePosition = length * 4;
      pageOffset = _pagePosition * cardWidth;
      _pagePosition = 0;
      pageOffset = 0;
      pageScrollController = ScrollController(
          keepScrollOffset: false, initialScrollOffset: pageOffset);
      pageScrollController.addListener(() {
        pageOffset = pageScrollController.offset;
        double nowOffset = pageOffset / (cardWidth);
        int next = nowOffset.floor();
        if (next < 0) {
          next = 0;
        }
        if (_pagePosition != next) {
          _pagePosition = next;
        }
        if (listener != null) {
          listener(_pagePosition, pageOffset);
        }
//        if (mounted) setState(() {});
      });
      _startTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
    pageScrollController?.dispose();
    pageScrollController = null;
  }

  @override
  Widget build(BuildContext context) {
    if (length <= 0) return Container();

//    return NotificationListener(
//      onNotification: (position){
//
//        return false;
//      },
//      child: CustomScrollView(
////        controller: pageScrollController,
//        scrollDirection: Axis.horizontal,
//        slivers: <Widget>[
//          _cellItem(0),
//          _cellItem(1),
//          _cellItem(2),
//          _cellItem(3),
//          _cellItem(4),
//        ],
//        physics: PagingScrollPhysics(
//            maxSize: kMiddleValue * length * cardWidth + 12,
//            itemDimension: cardWidth,
//            leadingSpacing: 0),
//      ),
//    );

    Widget child = ListView.builder(
      itemBuilder: (context, index) {

        return AnimatedBuilder(
          animation: pageScrollController,
          child: itemBuilder(context, index),
          builder: (context,child){

            var pre = 0.0;
            if (_pagePosition == index) {
              pre = (pageOffset - cardWidth * index) / cardWidth;
              if (pre < 0) {
                pre = -pre;
              }
            } else if (_pagePosition == index - 1) {
              pre = 1 - (index * cardWidth - pageOffset) / cardWidth;
              if (pre < 0) {
                pre = -pre;
              }
            } else if (_pagePosition == index - 2) {
              pre = 2 - (index * cardWidth - pageOffset) / cardWidth;
              if (pre < 0) {
                pre = -pre;
              }
            }
            var scale = _calScale(_pagePosition, index, pre);
            var offset = _calScale3(_pagePosition, index, pre);

            return Container(
              height: cardHeight,
              width: cardWidth + (index == 0 ? 12 : 0),
              alignment: Alignment.topCenter,
              child: Transform.scale(
                origin: (_pagePosition + 2 == index || _pagePosition + 3 == index)
                    ? Offset(offsetWidth * offset, 0)
                    : _pagePosition - 1 == index
                    ? Offset(-cardWidth / 2, 0)
                    : Offset(0, 0),
                scale: scale,
                child: child,
              ),
            );
          },
        );

//        return Container(
//          height: cardHeight,
//          width: cardWidth + (index == 0 ? 12 : 0),
//          alignment: Alignment.topCenter,
//          child: Transform.scale(
//            origin: (_pagePosition + 2 == index || _pagePosition + 3 == index)
//                ? Offset(offsetWidth * offset, 0)
//                : _pagePosition - 1 == index
//                ? Offset(-cardWidth / 2, 0)
//                : Offset(0, 0),
//            scale: scale,
//            child: itemBuilder(context, index),
//          ),
//        );
      },
      itemCount: kMiddleValue * length,
      scrollDirection: Axis.horizontal,
      physics: PagingScrollPhysics(
          maxSize: kMiddleValue * length * cardWidth + 12,
          itemDimension: cardWidth,
          leadingSpacing: 0),
      controller: pageScrollController,
    );
    child = Listener(
      onPointerDown: (event) {
        _cancelTimer();
      },
      onPointerCancel: (event) {
        _startTimer();
      },
      onPointerUp: (event) {
        _startTimer();
      },
      child: child,
    );
    return child;
  }

  double _calScale(int currentPosition, int thisPosition, double pre) {
    if (thisPosition == currentPosition) {
      return (1 - pre * (100 - offsetPre) / 100);
    } else if (thisPosition == currentPosition + 1) {
      return (offsetPre / 100 + pre * (100 - offsetPre) / 100);
    } else {
      return (offsetPre / 100);
    }
  }

  double _calScale3(int currentPosition, int thisPosition, double pre) {
    if (thisPosition == currentPosition + 2) {
      return pre - 1;
    } else if (thisPosition == currentPosition + 3) {
      return -1;
    } else {
      return 0;
    }
  }

  Widget _cellItem(int index){
    var pre = 0.0;
    if (_pagePosition == index) {
      pre = (pageOffset - cardWidth * index) / cardWidth;
      if (pre < 0) {
        pre = -pre;
      }
    } else if (_pagePosition == index - 1) {
      pre = 1 - (index * cardWidth - pageOffset) / cardWidth;
      if (pre < 0) {
        pre = -pre;
      }
    } else if (_pagePosition == index - 2) {
      pre = 2 - (index * cardWidth - pageOffset) / cardWidth;
      if (pre < 0) {
        pre = -pre;
      }
    }
    var scale = _calScale(_pagePosition, index, pre);
    var offset = _calScale3(_pagePosition, index, pre);
    return SliverToBoxAdapter(
      child: Container(
        height: cardHeight,
        width: cardWidth + (index == 0 ? 12 : 0),
        alignment: Alignment.topCenter,
        child: Transform.scale(
          origin: (_pagePosition + 2 == index || _pagePosition + 3 == index)
              ? Offset(offsetWidth * offset, 0)
              : _pagePosition - 1 == index
              ? Offset(-cardWidth / 2, 0)
              : Offset(0, 0),
          scale: scale,
          child: itemBuilder(context, index),
        ),
      ),
    );
  }
}
