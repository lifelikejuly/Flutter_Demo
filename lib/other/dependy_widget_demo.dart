import 'package:flutter/material.dart';
import 'debug_import.dart';


class DependyWidgetDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          TextWidget()
        ],
      ),
    );
  }
}
