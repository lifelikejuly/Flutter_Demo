import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/demo/animation/animation_live_demo.dart';

final String networkPic =
    "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2502384351,886196727&fm=26&gp=0.jpg";

class ImageListDemo extends StatefulWidget {
  @override
  _ImageListDemoState createState() => _ImageListDemoState();
}

class _ImageListDemoState extends State<ImageListDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemBuilder: (context, position) {
          return ListWidget(position);
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

class ListWidget extends StatefulWidget {
  final int index;

  ListWidget(this.index);

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  void initState() {
    super.initState();
    print("_ListWidgetState initState ${widget.index}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Image.asset("res/img/jay.jpg"),
    );
  }

  @override
  void dispose() {
    super.dispose();
    print("_ListWidgetState dispose ${widget.index}");
  }
}

class ImageBuilder extends StatelessWidget {
  final int index;

  ImageBuilder(this.index);

  @override
  Widget build(BuildContext context) {
    print("ImageBuilder --- num --- $index");
    return Container(
      height: 500,
      child: Column(
        children: <Widget>[
          Image.asset("res/img/jay.jpg"),
//          Container(
//            height: 200,
//            child: LiveAnimationWidget(),
//          )
        ],
      ),
    );
  }
}
