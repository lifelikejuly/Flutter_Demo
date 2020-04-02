import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TabBarDemo extends StatefulWidget {
  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            TabBar(
              labelColor: Colors.blue,
              tabs: [
                Tab(
                  text: "1",
                ),
                Tab(
                  text: "2",
                ),
                Tab(
                  text: "3",
                ),
                Tab(
                  text: "4",
                ),
              ],
              controller: tabController,
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  TabBarViewWidget("1"),
                  TabBarViewWidget("2"),
                  TabBarViewWidget("3"),
                  TabBarViewWidget("4"),
                ],
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
              ),
            )
          ],
        ));
  }
}

class TabBarViewWidget extends StatefulWidget {
  final String name;

  TabBarViewWidget(this.name);

  @override
  _TabBarViewWidgetState createState() => _TabBarViewWidgetState();
}

class _TabBarViewWidgetState extends State<TabBarViewWidget> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_){
      if (mounted) {
        print("TabBarViewWidget ${widget.name}");
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.name),
    );
  }
}
