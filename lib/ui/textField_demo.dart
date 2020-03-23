import 'package:flutter/material.dart';

class TextFieldDemo extends StatefulWidget {
  @override
  _TextFieldDemoState createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: (text) {
              print("TextField $text");
            },
          ),
        ],
      ),
    );
  }
}
