import 'package:flutter/material.dart';

class RowTextWithIconDemo extends StatefulWidget {
  @override
  _RowTextWithIconDemoState createState() => _RowTextWithIconDemoState();
}

class _RowTextWithIconDemoState extends State<RowTextWithIconDemo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              "我是长文本。。。。。。。。。。。",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Icon(Icons.add),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "我是长文本。。。。。。。。。。。",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Icon(Icons.add),
          ],
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: Text(
                "我是长文本。。。。。。。。。。。",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Icon(Icons.add),
          ],
        ),
        Text.rich(
          TextSpan(
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 10,
              fontWeight: FontWeight.w300,
            ),
            children: [
              TextSpan(
                text: "口感软糯",
                // style: TextStyle(
                //   color: Color(0xFF999999),
                //   fontSize: 12,
                // ),
              ),
              WidgetSpan(
                child: SizedBox(width: 10)
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child:  Image.asset(
                  "images/icon_left_sliver.png",
                  width: 10,
                  height: 10,
                ),
              )
            ],
          ),
          style: TextStyle(
            color: Color(0xFF999999),
            fontSize: 10,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
