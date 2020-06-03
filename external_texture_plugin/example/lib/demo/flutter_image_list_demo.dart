import 'package:externaltextureplugin_example/demo/mock.dart';
import 'package:flutter/material.dart';

class FlutterImageListDemo extends StatefulWidget {
  @override
  _FlutterImageDemoState createState() => _FlutterImageDemoState();
}

class _FlutterImageDemoState extends State<FlutterImageListDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter加载"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ImageFulWidget(index);
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
      imgs[widget.num % imgs.length],
      height: 100,
      width: 100,
    );
  }
}
