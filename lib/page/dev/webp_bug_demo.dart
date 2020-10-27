import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/gif_image.dart';

class WebpBugDemo extends StatefulWidget {
  @override
  _WebpBugDemoState createState() => _WebpBugDemoState();
}

class _WebpBugDemoState extends State<WebpBugDemo> {
  GifAssetImage gifAssetImage;
  GifAssetImage gifAssetImage2;

  @override
  void initState() {
    super.initState();
    gifAssetImage = GifAssetImage(
      "images/ic_love_gif.gif",
      replayDuration: Duration(seconds: 2),
      repetitionCount: 1,
    );

    gifAssetImage2 = GifAssetImage(
      "images/ic_love_gif.webp",
      replayDuration: Duration(seconds: 2),
      repetitionCount: 1,
    );
  }

  @override
  void dispose() {
    super.dispose();
    gifAssetImage?.dispose();
    gifAssetImage2?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Gif加载"),
        Container(
          child: GifImage.gif(
            image: gifAssetImage,
          ),
          color: Colors.black,
        ),
        Text("Webp加载"),
        Container(
          child: GifImage.gif(
            image: gifAssetImage2,
          ),
          color: Colors.black,
        ),
      ],
    );
  }
}
