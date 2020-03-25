import 'package:flutter/material.dart';

class ScrollDemo extends StatefulWidget {
  @override
  _ScrollViewDemoState createState() => _ScrollViewDemoState();
}

class _ScrollViewDemoState extends State<ScrollDemo> {
//  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
//    scrollController = ScrollController();
//    scrollController.addListener(() {
//      print("offset ${scrollController.offset}");
//    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Row(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: size.width / 2,
                color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                  ],
                ),
              ),
              physics: ClampingScrollPhysics(),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: size.width / 2,
                color: Colors.blueGrey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                    Text("1"),
                  ],
                ),
              ),
              physics: BouncingScrollPhysics(),
            ),
          ],
        ),
      ),
    );
  }
}
