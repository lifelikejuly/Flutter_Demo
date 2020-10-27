import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

class GifControllerDemo extends StatefulWidget {
  @override
  _GifControllerDemoState createState() => _GifControllerDemoState();
}

class _GifControllerDemoState extends State<GifControllerDemo>
    with TickerProviderStateMixin {
  GifController controller;

  @override
  void initState() {
    super.initState();
    controller = GifController(vsync: this);

//    gifAssetImage = GifAssetImage(
//      "images/ic_love_gif.gif",
//      replayDuration: Duration(seconds: 2),
//      repetitionCount: 1,
//    );
//
//    gifAssetImage2 = GifAssetImage(
//      "images/ic_love_gif.webp",
//      replayDuration: Duration(seconds: 2),
//      repetitionCount: 1,
//    );

  }
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: GifImage(
            controller: controller,
            image: AssetImage(
                "images/ic_love_gif.webp"),
          ),
          color: Colors.black,
        ),
        FlatButton(
          child: Text("tdo"),
          onPressed: (){
            controller.animateTo(48,duration: Duration(seconds: 1));
//            controller.value = 48;
          },
        ),
      ],
    );
  }
}
