import 'package:flutter/material.dart';

class TextAlignDemo extends StatefulWidget {
  @override
  _TextAlignDemoState createState() => _TextAlignDemoState();
}

class _TextAlignDemoState extends State<TextAlignDemo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              color: Color(0xFF999999),
              width: 0.5,
              height: 20,
            ),
            Text(
              "|口感软糯",
              style: TextStyle(
                color: Color(0xFF999999),
                fontSize: 20,
              ),
            ),
          ],
        ),
        Text.rich(
          TextSpan(
            text: "|",
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
            children: [
              TextSpan(
                text: "口感软糯",
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Text(
            "KKKGJgj普通Text：",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          color: Colors.teal,
        ),
        Container(
          child: Text(
            "abcdefjhijklmn小写字母Text：",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          color: Colors.teal,
        )
      ],
    );
  }
}
