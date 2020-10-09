import 'package:flutter/material.dart';
import 'package:flutter_demo/demo/tabbar/tabs.dart';

import 'no_tabbar.dart';
import 'underLineIndicator.dart';

class TabBarDemo111 extends StatefulWidget {
  @override
  _TabBarDemo1State createState() => _TabBarDemo1State();
}

class _TabBarDemo1State extends State<TabBarDemo111>
    with SingleTickerProviderStateMixin {
  List<String> tabs = [
    "关注",
    "发现",
    "明星饭圈",
    "寻味指南",
    "史莱姆",
    "妈咪宝贝",
    "汉服同袍",
  ];

  List<Widget> tabWidgets;
  List<Widget> tabPageViews;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabWidgets = List();
    tabPageViews = List();
    tabs.forEach((element) {
      tabWidgets.add(Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepOrange, width: 1),
            ),
            padding: EdgeInsets.only(bottom: 7.5),
            child: Text(
              element,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 15,
//                 ),
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ));
      tabPageViews.add(Container(
        child: Center(
          child: Text(element),
        ),
      ));
    });
    tabController = TabController(
      initialIndex: 0,
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DataScreen(),
    );
  }
}

const List<String> _titleList = [
  'test 1',
  'test 2',
  'test 3',
  'test 4',
  'test 5',
  'test 6',
  'test 7',
  'test 8',
  'test 9',
  'test 10',
];

class DataScreen extends StatelessWidget {
  static const String routeName = '/data/data_screen';

  const DataScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataPresentation();
  }
}

class DataPresentation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DataScreenState();
  }
}

class _DataScreenState extends State<DataPresentation>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _titleList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataScreenBody(context);
  }

  Widget _buildDataScreenBody(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          color: Colors.blueAccent,
          width: double.infinity,
          child: Align(
              alignment: Alignment.center,
              child: H_TabBar(
                labelPadding: EdgeInsets.symmetric(horizontal: 12),
                indicator: UnderLineIndicator(
                  borderSide: BorderSide(color: Color(0xFFFF1F50), width: 3),
                  insets: EdgeInsets.only(left: 12, right: 12, bottom: 2),
                  width: 25,
                ),
                controller: _tabController,
                indicatorSize: H_TabBarIndicatorSize.label,
                indicatorColor: Colors.white,
                indicatorWeight: 2.0,
                isScrollable: true,
                labelColor: Colors.white,
                labelStyle: TextStyle(fontSize: 16.0),
                unselectedLabelColor: Colors.white.withOpacity(0.5),
                unselectedLabelStyle: TextStyle(fontSize: 12.0),
                tabs: _titleList
                    .map(
                      (text) => H_Tab(text: text),
                    )
                    .toList(),
              ))),
      Expanded(
          child: H_TabBarView(controller: _tabController, children: [
        Test1(),
        Test2(),
        Test3(),
        Test4(),
        Test4(),
        Test4(),
        Test4(),
        Test4(),
        Test4(),
        Test4(),
      ]))
    ]);
  }
}

class Test1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.green, child: Text('Test1'));
  }
}

class Test2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.red, child: Text('Test2'));
  }
}

class Test3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.yellow, child: Text('Test3'));
  }
}

class Test4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.purple, child: Text('Test4'));
  }
}
