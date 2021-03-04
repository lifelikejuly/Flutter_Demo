import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/mock/img_mock.dart';
import 'package:flutter_demo/page/lib/waterfall/src/rendering/sliver_waterfall_flow.dart';
import 'package:flutter_demo/page/lib/waterfall/src/widgets/scroll_view.dart';

import 'dart:math';

class SubTabListPage extends StatefulWidget {
  final ScrollController scrollController;
  final int index;

  SubTabListPage(this.scrollController,this.index);

  @override
  _SubTabListPageState createState() => _SubTabListPageState();
}

class _SubTabListPageState extends State<SubTabListPage> {
  double offset = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print("<> SubTabListPage dispose");
  }

  @override
  Widget build(BuildContext context) {
    Widget child = WaterfallFlow.builder(
    key: PageStorageKey("SubTabListPage-${widget.index}"),
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        Widget child = CachedNetworkImage(
          imageUrl: mockImgs[index],
        );
        child = GestureDetector(
          child: child,
          onTap: () async {
            setState(() {});
          },
        );
        return child;
      },
      itemCount: mockImgs.length,
      gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 9,
        crossAxisSpacing: 9,
      ),
    );

    child = NotificationListener<ScrollNotification>(
      onNotification: (scroll) {
        if (scroll.metrics.axis != Axis.vertical) return false;
        offset = listenerScrollOffset(scroll, offset, widget.scrollController);
        return false;
      },
      child: child,
    );
    return child;
  }


  listenerScrollOffset(ScrollNotification position, double offset,
      ScrollController fatherController) {
    if (position is ScrollUpdateNotification &&
        position.depth == 0 &&
        position.metrics.axis == Axis.vertical) {
      if (!(fatherController?.hasClients ?? false)) return;
      double nowOffset = position.metrics.pixels;
      double fatherOffset = fatherController.offset;
      if (!position.metrics.atEdge && nowOffset > 50) {
        if (nowOffset >= offset) {
          if (fatherOffset < 44) {
            fatherOffset += (nowOffset - offset);
            fatherOffset = min(44, fatherOffset);
            fatherController?.jumpTo(fatherOffset);
          }
        } else {
          if (fatherOffset > 0) {
            fatherOffset -= (offset - nowOffset);
            fatherOffset = max(fatherOffset, 0);
            fatherController?.jumpTo(fatherOffset);
          }
        }
      } else {
        if (fatherOffset > 0 && nowOffset < offset) {
          fatherController?.jumpTo(0);
        }
      }
      return nowOffset;
    }
    return offset;
  }

}
