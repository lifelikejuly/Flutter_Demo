import 'package:flutter/material.dart';

class ScrollViewDemo extends StatefulWidget {
  @override
  _ScrollViewDemoState createState() => _ScrollViewDemoState();
}

class _ScrollViewDemoState extends State<ScrollViewDemo> {

  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener((){
      print("offset ${scrollController.offset}");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          width: double.infinity,
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
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
//              Text("1"),
            ],
          ),
        ),
        physics: BouncingScrollPhysics(),
      ),
    );
  }
}
