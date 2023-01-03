import 'package:flutter/material.dart';

class EmojiDemo extends StatefulWidget {
  @override
  _EmojiDemoState createState() => _EmojiDemoState();
}

class _EmojiDemoState extends State<EmojiDemo> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.blue,
          child:
          Text("String.fromCharCode(128513) + String.fromCharCode(128591)"),
        ),
        Container(
          color: Colors.blue,
          child:
              Text(String.fromCharCode(128513) + String.fromCharCode(128591)),
        ),
      ],
    );
  }
}
