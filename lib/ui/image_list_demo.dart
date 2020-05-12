import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

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
//      body: ListView(
//        children: List(1000).map((value){
//          return ImageBuilder(value);
//        }).toList(),
//      ),
      body: ListWidget(),
//      body: CustomScrollView(
//        slivers: <Widget>[
//          SliverList(
//              delegate: SliverChildBuilderDelegate(
//            (_, position) {
//              return ImageBuilder(position);
//            },
//            childCount: 1000,
//          )),
//        ],
//      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    PaintingBinding.instance.imageCache.clear();
  }
}

class ListWidget extends StatefulWidget {
  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  bool show = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        show = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: show,
      child: ListView.builder(
        itemBuilder: (context, position) {
          return ImageBuilder(position);
        },
        itemCount: 10,
      ),
    );
  }
}

class ImageBuilder extends StatelessWidget {
  final int index;

  ImageBuilder(this.index);

  @override
  Widget build(BuildContext context) {
    print("ImageBuilder --- num --- $index");
//    return Image.network(
//      networkPic,
//      loadingBuilder: (context, widget, loadingProgress) {
//        if (loadingProgress == null) {
//          print("ImageBuilder --- num --- $index -- success");
//          return widget;
//        }
//        return Center(
//          child: CircularProgressIndicator(
//            value: loadingProgress.expectedTotalBytes != null
//                ? loadingProgress.cumulativeBytesLoaded /
//                    loadingProgress.expectedTotalBytes
//                : null,
//          ),
//        );
//      },
//    );
//  return Text("sss");
//    return Column(
//      children: <Widget>[
//        Text("sss"),
//        Image.network(
//          networkPic,
//          loadingBuilder: (context, widget, loadingProgress) {
//            if (loadingProgress == null) {
//              print("ImageBuilder --- num --- $index -- success");
//              return widget;
//            }
//            return Center(
//              child: CircularProgressIndicator(
//                value: loadingProgress.expectedTotalBytes != null
//                    ? loadingProgress.cumulativeBytesLoaded /
//                        loadingProgress.expectedTotalBytes
//                    : null,
//              ),
//            );
//          },
//        )
//      ],
//    );
    return Container(
      child: Image.asset("res/img/jay.jpg"),
    );
  }
}
