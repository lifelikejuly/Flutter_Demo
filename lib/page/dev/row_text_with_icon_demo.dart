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
      ],
    );
  }
}
