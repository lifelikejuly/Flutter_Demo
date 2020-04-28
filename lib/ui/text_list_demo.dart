import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextListDemo extends StatefulWidget {
  @override
  _TextListDemoState createState() => _TextListDemoState();
}

class _TextListDemoState extends State<TextListDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemBuilder: (_, position) {
          return TextBuilder(position);
        },
        itemCount: 100,
      ),
    );
  }
}

class TextBuilder extends StatelessWidget {
  final int index;

  TextBuilder(this.index);

  @override
  Widget build(BuildContext context) {
    print("TextBuilder --- $index --- ");
    return Container(
      child: Text("$index"),
    );
  }
}
