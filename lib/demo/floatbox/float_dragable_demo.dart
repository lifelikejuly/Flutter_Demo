import 'package:flutter/material.dart';

class FloatDraggableDemo extends StatefulWidget {
  @override
  _FloatDraggableState createState() => _FloatDraggableState();
}

class _FloatDraggableState extends State<FloatDraggableDemo> {
  Offset offset = Offset(0.0, 0.0);
  String info = "";

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double appBarHeight = kToolbarHeight;

    return Scaffold(
      appBar: AppBar(
        title: Text("DraggableDemo"),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            left: offset.dx,
            top: offset.dy,
            child: Draggable(
              child: Box(),
              childWhenDragging: Container(),
              feedback: Box(),
              onDraggableCanceled: (Velocity velocity, Offset offset) {
                setState(() {
                  this.offset = Offset(
                      offset.dx, offset.dy - appBarHeight - statusBarHeight);
                });
              },
            ),
          ),
          Positioned(
            left: 100,
            top: 100,
            child: Draggable(
              child: Text("我只是演示使用"),
              childWhenDragging: Text(
                "我被拉出去了😢",
                style: TextStyle(color: Colors.red),
              ),
              feedback: Material(
                child: Text("我是拉出去的东西"),
              ),
              onDragEnd: (detail) {
                info +=
                    "Draggable onDragEnd ${detail.velocity.toString()} ${detail.offset.toString()}\n";
                setState(() {});
                print(
                    "Draggable onDragEnd ${detail.velocity.toString()} ${detail.offset.toString()}");
              },
              onDragCompleted: () {
                print("Draggable onDragCompleted");
                info += "Draggable onDragCompleted\n";
                setState(() {});
              },
              onDragStarted: () {
                info = "";
                print("Draggable onDragStarted");
                info += "Draggable onDragStarted\n";
                setState(() {});
              },
              onDraggableCanceled: (Velocity velocity, Offset offset) {
                print(
                    "Draggable onDraggableCanceled ${velocity.toString()} ${offset.toString()}");
                info +=
                    "Draggable onDraggableCanceled ${velocity.toString()} ${offset.toString()}\n";
                setState(() {});
              },
            ),
          ),
          Positioned(
            left: 150,
            top: 150,
            child: DragTarget(
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
              ) {
                return Container(
                  height: 80,
                  width: 80,
                  color: Colors.yellow,
                  child: Text("快到碗里来~~"),
                );
              },
            ),
          ),
          Positioned(
            bottom: 50,
            child: Text(info),
          ),
          Positioned(
            bottom: 10,
            child: Text("${offset.toString()}"),
          )
        ],
      ),
    );
  }
}

class Box extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      color: Colors.blueAccent,
      child: Text(
        "Box",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
