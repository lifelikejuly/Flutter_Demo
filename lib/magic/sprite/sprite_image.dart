import 'dart:async';
import 'package:flutter/widgets.dart';

class SpriteWidget extends StatefulWidget {
  final Image image;
  final Size spriteSize;

  final Duration duration;

  SpriteWidget({
    Key key,
    @required this.image,
    @required this.spriteSize,
    @required this.duration,
  }) : super(key: key);

  @override
  _SpriteWidgetState createState() => _SpriteWidgetState();
}

class _SpriteWidgetState extends State<SpriteWidget> {
  Image get image => widget.image;

  Size get spriteSize => widget.spriteSize;

  Duration get duration => widget.duration;
  // 当前显示的图片位置
  int currentIndex = 0;
  int currentTimes = 0;

  int startIndex = 0;

  int endIndex = 1;
  int playTimes = 0;

  // 定时器用来更新精灵图加载
  Timer timer;

  @override
  void initState() {
    currentIndex = startIndex;
    timer = Timer.periodic(duration, (timer) {
      if (currentTimes <= playTimes) {
        setState(() {
          if (currentIndex >= endIndex) {
            if (playTimes != 0) currentTimes++;
            if (currentTimes < playTimes || playTimes == 0)
              currentIndex = startIndex;
            else
              currentIndex = endIndex;
          } else
            currentIndex++;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // 使用container+Positioned来限制图片显示区域
    return Container(
      width: spriteSize.width,
      height: spriteSize.height,
      child: Stack(
        children: [
          Positioned(
              left: -spriteSize.width * currentIndex,
              top: -spriteSize.height * currentIndex,
              child: image)
        ],
      ),
    );
  }
}
