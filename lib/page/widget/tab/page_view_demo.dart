import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';

class PageViewDemo extends StatefulWidget {
  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  List<String> items = <String>['1', '2', '3', '4', '5'];

  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: PageView.custom(
            controller: pageController,
            // pageSnapping: false,
            childrenDelegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return KeepAlive(
                    data: items[index],
                    key: ValueKey<String>(items[index]),
                  );
                },
                childCount: items.length,
                findChildIndexCallback: (Key key) {
                  final ValueKey valueKey = key;
                  final String data = valueKey.value;
                  return items.indexOf(data);
                }),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items
                .map((e) => RaisedButton(
              child: Text(e),
              onPressed: () {
                pageController.jumpToPage(int.parse(e) - 1);
              },
            ))
                .toList(),
          ),
        )
      ],
    );
  }
}

class KeepAlive extends StatefulWidget {
  const KeepAlive({Key key, this.data}) : super(key: key);
  final String data;

  @override
  _KeepAliveState createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAlive> {
  @override
  void initState() {
    super.initState();
    print("<> _KeepAliveState initState ${widget.data}");
  }

  @override
  void dispose() {
    super.dispose();
    print("<> _KeepAliveState dispose ${widget.data}");
  }

  @override
  Widget build(BuildContext context) {
    print("<> _KeepAliveState build ${widget.data}");
    return Common.getWidget(int.parse(widget.data));
  }
}
