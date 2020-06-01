import 'package:flutter/material.dart';

class ListViewDemo extends StatefulWidget {
  @override
  _ListViewDemoState createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: 200,
        color: Colors.yellow,
        padding: EdgeInsets.only(top: 10,bottom: 10),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, position) {
            return Container(
              width: 100,
              height: 100,
              color: Colors.blue,
              child: Text("sssss"),
            );
          },
          itemCount: 10,
        ),
      ),
    );
  }
}


