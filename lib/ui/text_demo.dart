import 'package:flutter/material.dart';

class TextDemo extends StatefulWidget {
  @override
  _TextDemoState createState() => _TextDemoState();
}


class NumClass{
  int num;

  NumClass({this.num});
}
class _TextDemoState extends State<TextDemo> {

  NumClass numClass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Visibility(
              visible: num == 1,
              child: Text(
                "SHOW ME",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
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
            ),
            Text(
              "SSSSssssSSSJAKC湿哒哒多所SSSSssssSSSJAKC湿哒哒多所多所多付付付付SSSSssssSSSJAKC湿哒哒多所多所多付付付付SSSSssssSSSJAKC湿哒哒多所多所多付付付付SSSSssssSSSJAKC湿哒哒多所多所多付付付付多所多付付付付",
              style: TextStyle(
                fontSize: 15,
                fontFamily: "",
                height: 1,
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  "在Row里面显示 SSSSssssSSSJAKC湿哒哒多所SSSSssssSSSJAKC湿哒哒多所多所多付付付付SSSSssssSSSJAKC湿哒哒多所多所多付付付付SSSSssssSSSJAKC湿哒哒多所多所多付付付付SSSSssssSSSJAKC湿哒哒多所多所多付付付付多所多付付付付",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "",
                    height: 1,
                  ),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  "在Column里面显示 SSSSssssSSSJAKC湿哒哒多所SSSSssssSSSJAKC湿哒哒多所多所多付付付付SSSSssssSSSJAKC湿哒哒多所多所多付付付付SSSSssssSSSJAKC湿哒哒多所多所多付付付付SSSSssssSSSJAKC湿哒哒多所多所多付付付付多所多付付付付",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "",
                    height: 1,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
