import 'package:flutter/material.dart';

import 'DIYReorderableListView.dart';

class SliverReorderListViewDemo extends StatefulWidget {
  @override
  _SliverReorderListViewDemoState createState() =>
      _SliverReorderListViewDemoState();
}

class _SliverReorderListViewDemoState extends State<SliverReorderListViewDemo> {
  final _titles = [
    'OC',
    'Swift',
    'Java',
    'C',
    'C++',
    'C#',
    'Dart',
    'Python',
    'Go'
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // scrollDirection: Axis.horizontal,
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: DIYReorderableListView(
              header: Container(
                width: 100,
                color: Colors.amber,
              ),
              footer: SizedBox(),
              extraWrapper: <Widget>[
                Text(
                  "封面",
                  style: TextStyle(color: Color(0xFFF5F5F5), fontSize: 11),
                )
              ],
              children: buildItems(),
              scrollDirection: Axis.horizontal,
              onReorder: (int oldIndex, int newIndex) async {
                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ),
        ),
        // SliverReorderListView.count(
        //   children: buildItems(),
        //   onReorder: (int oldIndex, int newIndex) async {
        //     if (mounted) {
        //       setState(() {});
        //     }
        //   },
        //   ignoringFeedbackSemantics: true,
        // ),
        // SliverReorderGridView.count(
        //   children: buildItems(),
        //   onReorder: (int oldIndex, int newIndex) async {
        //     if (mounted) {
        //       setState(() {});
        //     }
        //   },
        //   crossAxisCount: 4,
        //   mainAxisSpacing: 7,
        //   crossAxisSpacing: 7,
        //   ignoringFeedbackSemantics: true,
        // ),
      ],
    );
  }

  List<Widget> buildItems() {
    List<Widget> items = List<Widget>();
    _titles.forEach((value) {
      items.add(baseItem(value));
    });
    return items;
  }

  Widget baseItem(value) {
    return Container(
      key: Key(value),
      width: 110,
      height: 110,
      color: Colors.blue,
      child: Center(
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.yellowAccent),
        ),
      ),
    );
  }
}
