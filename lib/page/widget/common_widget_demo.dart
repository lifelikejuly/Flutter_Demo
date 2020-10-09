import 'package:flutter/material.dart';
import 'package:flutter_demo/base/base_widget_ui.dart';

class CommonWidgetDemo extends StatefulWidget {
  final Map<String, Widget> widgets;

  CommonWidgetDemo(this.widgets);

  @override
  _CommonWidgetDemoState createState() => _CommonWidgetDemoState();
}

class _CommonWidgetDemoState extends State<CommonWidgetDemo> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.widgets.entries.map((e) {
        return FlatButton(
          child: Text(e.key),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => BaseViewPage(e.key, e.value),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
