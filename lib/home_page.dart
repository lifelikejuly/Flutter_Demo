import 'package:flutter/material.dart';
import 'package:flutter_demo/base/base_widget_ui.dart';

import 'table_contents.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter学习试验田'),
      ),
      body: ListView(
        children: TableContents.tables.entries.map((e) {
          return FlatButton(
            child: Text(e.key),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      BaseListPage(e.key, e.value),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
