import 'package:flutter/material.dart';


final String networkPic =
    "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2502384351,886196727&fm=26&gp=0.jpg";


//class FlutterImageDemo extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Flutter加载"),
//      ),
//      body: ListView.builder(
//        itemBuilder: (context, index) {
//          return ImageFulWidget(index);
//        },
//        itemCount: 300,
//      ),
//    );
//  }
//}

class FlutterImageDemo extends StatefulWidget {
  @override
  _FlutterImageDemoState createState() => _FlutterImageDemoState();
}

class _FlutterImageDemoState extends State<FlutterImageDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter加载"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ImageLessWidget(index);
        },
        itemCount: 300,
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    PaintingBinding.instance.imageCache.clear();
  }
}


class ImageLessWidget extends StatelessWidget {
  final int num;

  ImageLessWidget(this.num);

  @override
  Widget build(BuildContext context) {
    print("ImageLessWidget build $num");
    return Image.asset(
      "res/img/jay.jpg",
      height: 100,
      width: 100,
    );
  }
}

class ImageFulWidget extends StatefulWidget {
  final int num;

  ImageFulWidget(this.num);

  @override
  _ImageFulWidgetState createState() => _ImageFulWidgetState();
}

class _ImageFulWidgetState extends State<ImageFulWidget> {
  @override
  void initState() {
    super.initState();
    print("_ImageFulWidgetState initState ${widget.num}");
  }

  @override
  void dispose() {
    super.dispose();
    print("_ImageFulWidgetState dispose ${widget.num}");
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "res/img/jay.jpg",
      height: 100,
      width: 100,
    );
  }
}
