import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demo/demo/drawer/gesture_drag_drawerx.dart';

class DrawerDemo extends StatefulWidget {
  @override
  _DrawerDemoState createState() => _DrawerDemoState();
}

class _DrawerDemoState extends State<DrawerDemo> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double top  = MediaQueryData.fromWindow(window).padding.top;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.red,
        child: Stack(
          children: <Widget>[
            GestureDragDrawer(
              direction: DragDirection.top,
              childSize: 200,
              originOffset: 50,
              parentWidth: size.width,
              parentHeight: size.height,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.black,
                child: Center(
                  child: Text("DrawerDemo"),
                ),
              ),
            ),
            Positioned(
              child: GestureDragDrawer(
                direction: DragDirection.left,
                childSize: 200,
                originOffset: 50,
                parentWidth: size.width,
                parentHeight: size.height,
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.black,
                  child: Center(
                    child: Text("DrawerDemo"),
                  ),
                ),
              ),
              top: 250,
            ),
            Positioned(
              child: GestureDragDrawer(
                direction: DragDirection.right,
                childSize: 200,
                originOffset: 50,
                parentWidth: size.width,
                parentHeight: size.height,
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.black,
                  child: Center(
                    child: Text("DrawerDemo"),
                  ),
                ),
              ),
              top: 450,
            ),
            GestureDragDrawer(
              direction: DragDirection.bottom,
              childSize: 200,
              originOffset: 50,
              parentWidth: size.width,
              parentHeight: size.height - kToolbarHeight - top,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.black,
                child: Center(
                  child: Text("DrawerDemo"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
