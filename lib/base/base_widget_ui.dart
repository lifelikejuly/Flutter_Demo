import 'package:flutter/material.dart';

class BaseListPage extends StatefulWidget {
  final String title;
  final Map<String, Widget> tables;

  BaseListPage(this.title, this.tables);

  @override
  _BaseListPageState createState() => _BaseListPageState();
}

class _BaseListPageState extends State<BaseListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: widget.tables.entries.map((e) {
          return FlatButton(
            child: Text(e.key),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      BaseViewPage(e.key, e.value),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class BaseViewPage extends StatefulWidget {
  final String title;
  final Widget view;

  BaseViewPage(this.title, this.view);

  @override
  _BaseViewPageState createState() => _BaseViewPageState();
}

class _BaseViewPageState extends State<BaseViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: widget.view,
    );
  }
}
