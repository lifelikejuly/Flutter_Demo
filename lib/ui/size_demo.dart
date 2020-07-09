import 'package:flutter/material.dart';

class SizeDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double proWidth = 200 / 750;

    return Scaffold(
      appBar: AppBar(
        title: Text("UI设计稿尺寸问题"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: 200,
            height: 100,
            child: Center(
              child: Text("固定大小的200x100"),
            ),
            color: Colors.amber,
          ),
          Container(
            width: proWidth * size.width,
            height: proWidth * size.width * 100 / 200,
            child: Center(
              child: Text(
                "适配屏幕的200x100 \n ${proWidth * size.width} \n ${proWidth * size.width * 100 / 200}",
                style: TextStyle(fontSize: 10),
              ),
            ),
            color: Colors.brown,
          )
        ],
      ),
    );
  }
}
