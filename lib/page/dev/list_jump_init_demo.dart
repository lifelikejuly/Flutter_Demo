import 'package:flutter/material.dart';
import 'package:flutter_demo/mock/img_mock.dart';

class ListJumpInitDemo extends StatefulWidget {
  @override
  _ListJumpInitDemoState createState() => _ListJumpInitDemoState();
}

class _ListJumpInitDemoState extends State<ListJumpInitDemo>
    with TickerProviderStateMixin {
  ScrollController scrollController;
  PageController pageController;


  /// 还是没搞明白ListView初始化过程 感觉设置了initialScrollOffset build还是会从第一个cell开始。
  ///
  ///
  /// 需要设置itemExtent 使用反正还是会从第一个cell开始build直到初始化的cell
  ///
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return _cellItem("<ListJumpInitDemo> ListView", index);
              },
              itemCount: 50,
              controller: scrollController,
              cacheExtent: 500 * 5.0,
            ),
          ),
          Container(
            height: 200,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return _cellItem("<ListJumpInitDemo> PageView", index);
              },
              itemCount: 100,
              controller: pageController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cellItem(String log, int index) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: 300,
      width: 200,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(
            mockImgs[index],
//            frameBuilder: (
//                BuildContext context,
//                Widget child,
//                int frame,
//                bool wasSynchronouslyLoaded,
//            ){
//              if(wasSynchronouslyLoaded){
//                print(
//                    "$log - ${mockImgs[index]} - $index ");
//
//              }
//              return child;
//            },
            loadingBuilder: (
              context,
              child,
              loadingProgress,
            ) {
              if(loadingProgress == null){
                print(
                    "$log - ${mockImgs[index]} - $index");
              }else{
                print(
                    "$log - ${mockImgs[index]} - $index ${loadingProgress.cumulativeBytesLoaded}/${loadingProgress.expectedTotalBytes}");
              }
              return child;
            },
          ),
          Center(
            child: Text(
              "$index",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController =
        ScrollController(initialScrollOffset: 500 * 25.0, keepScrollOffset: false);
    pageController = PageController(initialPage: 10);
  }
}
