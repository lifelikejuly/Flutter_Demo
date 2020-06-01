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
          return ContentFulWidget(position);
        },
        itemCount: 1000,
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

class ContentFulWidget extends StatefulWidget {
  final int index;

  ContentFulWidget(this.index);

  @override
  _ContentFulWidgetState createState() => _ContentFulWidgetState();
}

class _ContentFulWidgetState extends State<ContentFulWidget> {

  @override
  void initState() {
    super.initState();
    print("_ContentFulWidgetState initState ${widget.index}");
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("${widget.index}"),
    );
  }
  @override
  void dispose() {
    super.dispose();
    print("_ContentFulWidgetState dispose ${widget.index}");
  }
}
