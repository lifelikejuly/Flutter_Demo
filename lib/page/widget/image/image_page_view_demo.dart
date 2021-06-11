import 'package:flutter/widgets.dart';
import 'package:flutter_demo/mock/img_mock.dart';
import 'package:flutter_demo/page/diy/preview/full_size_image_view_copy.dart';

class ImagePageViewDemo extends StatefulWidget {
  @override
  _ImagePageViewDemoState createState() => _ImagePageViewDemoState();
}

class _ImagePageViewDemoState extends State<ImagePageViewDemo> {
  @override
  Widget build(BuildContext context) {
    // return PageView(
    //   children: pageViewImages
    //       .map((e) =>  BigImagesContainerCopy(
    //               startRect: Rect.zero,
    //               pop: (){
    //                 Navigator.of(context).pop();
    //               },
    //               builder:(context){
    //                 return SingleChildScrollView(
    //                   child: Image.network(
    //                     e,
    //                     fit: BoxFit.fitWidth,
    //                   ),
    //                 );
    //               },
    //           ))
    //       .toList(),
    // );

    // return BigImagesContainerCopy(
    //   startRect: Rect.zero,
    //   pop: () {
    //     Navigator.of(context).pop();
    //   },
    //   builder: (context) {
    //     return PageView(
    //       children: pageViewImages
    //           .map((e) => SingleChildScrollView(
    //                 child: Image.network(
    //                   e,
    //                   fit: BoxFit.fitWidth,
    //                 ),
    //               ))
    //           .toList(),
    //     );
    //   },
    // );

    // return PageView(
    //   children: pageViewImages
    //       .map((e) => SingleChildScrollView(
    //     child: Image.network(
    //       e,
    //       fit: BoxFit.fitWidth,
    //     ),
    //   ))
    //       .toList(),
    // );

    return PageView.builder(
      itemBuilder: (context,index){
        print("<> PageView.builder index $index ");
        return SingleChildScrollView(
          child: Image.network(
            pageViewImages[index],
            fit: BoxFit.fitWidth,
          ),
        );
      },
      // children: pageViewImages
      //     .map((e) => SingleChildScrollView(
      //   child: Image.network(
      //     e,
      //     fit: BoxFit.fitWidth,
      //   ),
      // ))
      //     .toList(),
    );
  }
}

class CellItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
