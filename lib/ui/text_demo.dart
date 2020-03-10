import 'package:flutter/material.dart';

class TextDemo extends StatefulWidget {
  @override
  _TextDemoState createState() => _TextDemoState();
}

class _TextDemoState extends State<TextDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              "嘻嘻哈哈SSSSssss你是谁啊？阿哟喂~！",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  "SSSSssssSSSJAKC",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "",
                    height: 1,
                  ),
                ),
                Text(
                  "嘻嘻哈哈",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "",
                    height: 1,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Text(
                  "SSSSssssSSSJAKC",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "",
                  ),
                ),
                Text(
                  "嘻嘻哈哈",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "",
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "SSSSssssSSSJAKC",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "",
                    ),
                  ),
                ),
                Container(
                  color: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "嘻嘻哈哈",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "",
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "SSSSssssSSSJAKC",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "",
                      height: 1,
                    ),
                  ),
                ),
                Container(
                  color: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "嘻嘻哈哈",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "",
                      height: 1,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
