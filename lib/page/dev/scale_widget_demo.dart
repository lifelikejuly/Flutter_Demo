import 'package:flutter/material.dart';

class ScaleWidgetDemo extends StatefulWidget {
  @override
  State<ScaleWidgetDemo> createState() => _ScaleWidgetDemoState();
}

class _ScaleWidgetDemoState extends State<ScaleWidgetDemo>
    with TickerProviderStateMixin {
  AnimationController _scaleAnimationController;
  Animation<double> scale;

  // GlobalKey globalKey = GlobalKey();

  double width = 0;

  @override
  void initState() {
    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    scale = Tween(begin: 1.0, end: 1.29).animate(_scaleAnimationController);
    super.initState();
  }

  @override
  void dispose() {
    _scaleAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _scaleAnimationController.reset();
          _scaleAnimationController.forward();
        },
        child: Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 50, top: 50),
          color: Colors.yellow,
          width: 300,
          height: 300,
          child: Stack(
            children: [
              Container(
                height: 100,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return _itemCell(index);
                  },
                  itemCount: 10,
                ),
              ),
            ],
          ),
        ));
  }

  _itemCell(int index) {
    return AnimatedBuilder(
      animation: scale,
      builder: (context, widget) {
        if (index == 3) {
          // if (width == 0 &&
          //     globalKey != null &&
          //     globalKey.currentContext != null &&
          //     globalKey.currentContext.size != null) {
          //   width = globalKey.currentContext.size.width;
          // }
          return Transform.scale(
            alignment: Alignment.centerLeft,
            scale: scale.value,
            child: Padding(
              padding: EdgeInsets.only(right: width * 0.37),
              child: widget,
            ),
          );
        }
        return widget;
      },
      child: (index == 3 && width == 0)
          ?
      Container(
        // key: globalKey,
        margin: EdgeInsets.only(left: 15, right: 15),
        color: Colors.blue,
        width: 100,
        height: 50,
        child: Text("globalKey"),
      )
          : Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              color: Colors.blue,
              width: 100,
              height: 50,
              child: Text("AnimatedBuilder"),
            ),
    );
  }
}
