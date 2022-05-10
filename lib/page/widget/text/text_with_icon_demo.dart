import 'package:flutter/material.dart';

class TextWithIconDemo extends StatefulWidget {
  @override
  _TextWithIconDemoState createState() => _TextWithIconDemoState();
}

class _TextWithIconDemoState extends State<TextWithIconDemo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "fjhijklmn我是文本GHIJKLMN",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: 20),
            ),
            Image.asset(
              "images/icon_left_sliver.png",
              width: 15,
              height: 15,
            )
          ],
        ),
        Text.rich(
          TextSpan(children: [
            TextSpan(
                text: "fjhijklmn我是文本GHIJKLMN", style: TextStyle(fontSize: 20)),
            WidgetSpan(
                style: TextStyle(fontSize: 20),
                alignment: PlaceholderAlignment.middle,
                child: Image.asset(
              "images/icon_left_sliver.png",
              width: 15,
              height: 15,
            )),
          ]),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          softWrap: true,
        ),
      ],
    );
  }
}
