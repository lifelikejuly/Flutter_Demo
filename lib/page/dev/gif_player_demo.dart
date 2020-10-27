import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/gif_image.dart';

class GifPlayerDemo extends StatefulWidget {
  @override
  _GifPlayerDemoState createState() => _GifPlayerDemoState();
}

class _GifPlayerDemoState extends State<GifPlayerDemo> {
  String picRes1 =
      "http://wx2.sinaimg.cn/bmiddle/ceeb653ely1g4xhw7xasrg207d054njs.gif";

  int repetitionCount = 1;
  Duration duration = Duration(seconds: 3);
  bool reverse = true;

  GifNetworkImage gifNetworkImage;
  GifAssetImage gifAssetImage;

  @override
  void initState() {
    super.initState();
    gifNetworkImage = GifNetworkImage(
      picRes1,
      repetitionCount: repetitionCount,
      replayDuration: duration,
      reverse: false,
    );
    gifAssetImage = GifAssetImage(
      "images/gif_player_demo.gif",
      replayDuration: Duration(seconds: 2),
      repetitionCount: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        GifImage.gif(image: gifNetworkImage),
        Row(
          children: <Widget>[
            RaisedButton(
              child: Text("无限循环"),
              onPressed: () {
                repetitionCount = -1;
                duration = null;
                gifNetworkImage?.updatePlayConfig(
                  repetitionCount: repetitionCount,
                  replayDuration: duration,
                );
                setState(() {});
              },
            ),
            RaisedButton(
              child: Text("循环3+重播"),
              onPressed: () {
                repetitionCount = 1;
                duration = Duration(seconds: 3);
                gifNetworkImage?.updatePlayConfig(
                  repetitionCount: repetitionCount,
                  replayDuration: duration,
                );
                setState(() {});
              },
            ),
            RaisedButton(
              child: Text("播放倒序"),
              onPressed: () {
                repetitionCount = -1;
                duration = null;
                reverse = !reverse;
                gifNetworkImage?.updatePlayConfig(
                  reverse: reverse,
                  repetitionCount: repetitionCount,
                  replayDuration: duration,
                );
                setState(() {});
              },
            )
          ],
        ),
        GifImage.gif(
          image: gifAssetImage,
        ),
        Row(
          children: <Widget>[
            RaisedButton(
              child: Text("无限循环"),
              onPressed: () {
                gifAssetImage?.updatePlayConfig(
                  repetitionCount: -1,
                  replayDuration: null,
                );
                setState(() {});
              },
            ),
            RaisedButton(
              child: Text("循环3+重播"),
              onPressed: () {
                gifAssetImage?.updatePlayConfig(
                  repetitionCount: 3,
                  replayDuration: Duration(seconds: 3),
                );
                setState(() {});
              },
            )
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    gifAssetImage?.dispose();
    gifNetworkImage?.dispose();
  }
}
