
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BigHeightImageDemo extends StatefulWidget {
  @override
  _BigHeightImageDemoState createState() => _BigHeightImageDemoState();
}

class _BigHeightImageDemoState extends State<BigHeightImageDemo> {


  final String url = "https://wx3.sinaimg.cn/mw690/006f8wK2gy1gq1ied3kc3j60ku2siu0x02.jpg";

  double _screenWidth;

  bool loaded = false;
  @override
  void initState() {
    super.initState();
    // Image image = Image.network(url);
    // image.image
    //     .resolve(new ImageConfiguration())
    //     .addListener(new ImageStreamListener(
    //       (ImageInfo info, bool _) {
    //     print('model.======${info.image.width} xxx ${info.image.height}');
    //     loaded = true;
    //     setState(() {
    //
    //     });
    //   },
    // ));
  }

  @override
  Widget build(BuildContext context) {


    _screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Image.network(url,fit: BoxFit.fitWidth,) ,
    );
  }
}
