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
              Text(String.fromCharCode(128513) + String.fromCharCode(128591)),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 200,
          child: Stack(
            // fit: StackFit.expand,
            children: [
              Container(
                width: 100,
                height: 50,
                color: Colors.red,
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 200,
                child: Container(
                  width: 100,
                  height: 50,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
