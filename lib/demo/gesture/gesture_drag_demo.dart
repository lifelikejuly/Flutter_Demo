import 'package:flutter/material.dart';

class GestureDragDemo extends StatefulWidget {
  @override
  _GestureDragDemoState createState() => _GestureDragDemoState();
}

class _GestureDragDemoState extends State<GestureDragDemo> {
  List<String> verticalDragEvents = List();
  List<String> dragEvents = List();

  String verticalDragEvent = "";
  String horizontalDragEvent = "";
  String panDragEvent = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      child: Center(
                        child: Text(verticalDragEvent),
                      ),
                      color: Colors.red,
                    ),
                    onVerticalDragStart: (DragStart) {},
                    onVerticalDragUpdate: (DragUpdate) {
                      verticalDragEvent = DragUpdate.delta.toString();
                      setState(() {});
                    },
                    onVerticalDragDown: (DragDown) {},
                    onVerticalDragCancel: () {},
                    onVerticalDragEnd: (DragEnd) {},
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      child: Center(
                        child: Text(horizontalDragEvent),
                      ),
                      color: Colors.blue,
                    ),
                    onHorizontalDragStart: (DragStart) {},
                    onHorizontalDragUpdate: (DragUpdate) {
                      horizontalDragEvent = DragUpdate.delta.toString();
                      setState(() {});
                    },
                    onHorizontalDragDown: (DragDown) {},
                    onHorizontalDragCancel: () {},
                    onHorizontalDragEnd: (DragEnd) {},
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              child: Container(
                child: Center(
                  child: Text(panDragEvent),
                ),
                color: Colors.green,
              ),
              onPanStart: (panStart) {},
              onPanDown: (panDown) {},
              onPanEnd: (panEnd) {},
              onPanUpdate: (panUpdate) {
                panDragEvent = panUpdate.delta.toString();
                setState(() {});
              },
              onPanCancel: () {},
            ),
          )
        ],
      ),
    );
  }
}
