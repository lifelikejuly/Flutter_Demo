import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ContainerPage extends StatefulWidget {
  final Widget child;

  ContainerPage(this.child);

  @override
  _ContainerPageState createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: widget.child,
        ));
  }
}
