

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/mock/img_mock.dart';
import 'package:flutter_demo/page/lib/photo_view/photo_view.dart';

import 'photo_view/photo_view_gallery.dart';

class PhotoViewDemo extends StatefulWidget {
  @override
  _PhotoViewDemoState createState() => _PhotoViewDemoState();
}

class _PhotoViewDemoState extends State<PhotoViewDemo> {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: PhotoViewGallery.builder(
    //     scrollPhysics: ClampingScrollPhysics(),
    //     builder: _buildItem,
    //     itemCount: 5,
    //     backgroundDecoration: BoxDecoration(color: Colors.transparent),
    //   ),
    // );

    return Container(
      child: PhotoViewGallery(
        scrollPhysics: ClampingScrollPhysics(),
        pageOptions: mockImgs.map((e) => PhotoViewGalleryPageOptions.customChild(
            child: Image.network(e,fit: BoxFit.fill),
            childSize: Size(200,200),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            basePosition: Alignment.topCenter
        )).toList(),
        backgroundDecoration: BoxDecoration(color: Colors.transparent),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    print("<> _buildItem index $index");
    final String item = mockImgs[index];
    return PhotoViewGalleryPageOptions.customChild(
      child: Image.network(item,fit: BoxFit.fill),
      childSize: Size(200,200),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 2,
      basePosition: Alignment.topCenter
    );
  }
}



class CommonExampleRouteWrapper extends StatelessWidget {
  const CommonExampleRouteWrapper({
    this.imageProvider,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialScale,
    this.basePosition = Alignment.center,
    this.filterQuality = FilterQuality.none,
    this.disableGestures,
    this.errorBuilder,
  });

  final ImageProvider imageProvider;
  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final dynamic initialScale;
  final Alignment basePosition;
  final FilterQuality filterQuality;
  final bool disableGestures;
  final ImageErrorWidgetBuilder errorBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
          imageProvider: imageProvider,
          loadingBuilder: loadingBuilder,
          backgroundDecoration: backgroundDecoration,
          minScale: minScale,
          maxScale: maxScale,
          initialScale: initialScale,
          basePosition: basePosition,
          filterQuality: filterQuality,
          disableGestures: disableGestures,
          errorBuilder: errorBuilder,
        ),
      ),
    );
  }
}