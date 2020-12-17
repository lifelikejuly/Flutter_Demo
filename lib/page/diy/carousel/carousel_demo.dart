import 'package:flutter/material.dart';

import 'carousel.dart';


class CarouselDemo extends StatefulWidget {
  @override
  _CarouselDemoState createState() => _CarouselDemoState();
}

class _CarouselDemoState extends State<CarouselDemo> {
  // 卡片与屏幕
  double scaleW = 176 / 375;

  // 卡片尺寸
  double scaleC = 176 / 230;

  // banner尺寸
  double scaleB = 176 / 225;

  // 间距
  double scaleP = 188 / 375;

  double sWidth;

  double cardWidth;

  double cardHeight;

  double bannerHeight;

  double boxWidth;

  double offsetWidth;

  int position = 0;

  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    cardWidth = sWidth * scaleW;
    cardHeight = cardWidth / scaleC;
    bannerHeight = cardWidth / scaleB;
    boxWidth = sWidth * scaleP;

    offsetWidth = (cardWidth * 89 / 100) / 2;

    Widget child = StaticBubbleCarousel(
      cardWidth: cardWidth,
      cardHeight: cardHeight,
      offsetWidth: offsetWidth,
      length: 10,
      kMiddleValue: 100,
      offsetPre: 89,
      itemBuilder: (context, index) {
        return Container(
          width: cardWidth,
          height: cardHeight,
          color: Colors.orange,
          child: Center(
            child: Text(
              "$index",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
      listener: (page, offset) {
        position = page;
        setState(() {});
      },
    );
    child = Container(
      height: cardHeight,
      child: child,
    );
    return Column(
      children: [
        child,
      ],
    );
  }
}
