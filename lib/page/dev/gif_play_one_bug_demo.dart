

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class GifPlayOnceBugDemo extends StatefulWidget {
  @override
  _GifPlayOnceBugDemoState createState() => _GifPlayOnceBugDemoState();
}

class _GifPlayOnceBugDemoState extends State<GifPlayOnceBugDemo> {

  Key key = Key("loop");
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Text("带有loop的gif只播放一次后重新进页面不播放了。"),
        Image.asset(
            "images/gif_player_one.gif"),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    // 一种方式是清除缓存
    // PaintingBinding.instance.imageCache.clear();
  }
}
