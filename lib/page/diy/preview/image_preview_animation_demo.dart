

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'full_size_image_view_copy.dart';

class ImagePreviewAnimationDemo extends StatefulWidget {
  @override
  _ImagePreviewAnimationDemoState createState() => _ImagePreviewAnimationDemoState();
}

class _ImagePreviewAnimationDemoState extends State<ImagePreviewAnimationDemo> {


  String imageUrl = "https://b-ssl.duitang.com/uploads/item/201807/13/20180713120020_umtgg.thumb.700_0.jpg"; // 229.2, 703.0 -> 360,1104.1


  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // imageUrl = "http://pic37.nipic.com/20140113/8800276_184927469000_2.png"; // 380 : 178.6
    imageUrl = "http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1207/09/c1/12275680_1341814069049.jpg"; // 360 : 135
    imageUrl = "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fwww.2008php.com%2F2013_Website_appreciate%2F2013-05-17%2F20130517195204.jpg&refer=http%3A%2F%2Fwww.2008php.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1623832691&t=a592905b8c67674f7f882b4b3eb6abc0"; // 360,202
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox renderBox = globalKey.currentContext.findRenderObject();
      print("<> renderBox ${renderBox.size.toString()}");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          BigImagesContainerCopy<Map>(
            builder: (context, {widgetMove, valueUpdate, rectUpdate}) {
              return Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
              );
            },
            endRectList: [Rect.fromLTRB(0, 0, 360, 202)],
            pop: () {
              Navigator.pop(context);
            },
            startRect: Rect.fromLTRB(0, 0, 100, 100),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.network(
              imageUrl,
              fit: BoxFit.fitWidth,
              key: globalKey,
            ),
          )
        ],
    );
  }
}
