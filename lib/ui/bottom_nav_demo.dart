import 'package:flutter/material.dart';

class BottomNavDemo extends StatefulWidget {
  @override
  _BottomNavDemoState createState() => _BottomNavDemoState();
}

class _BottomNavDemoState extends State<BottomNavDemo> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<BottomNavigationBarItem> _navItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      title: Text('Business'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school),
      title: Text('School'),
    ),
  ];

  /// 底部栏新增和删除只能通过重新赋值更新，直接操作数组remove和add方法不行
  ///
  _updateAddNavs() {
    _navItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.business),
        title: Text('Business'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.school),
        title: Text('School'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.map),
        title: Text('Map'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.ondemand_video),
        title: Text('Video'),
      ),
    ];
    _widgetOptions = <Widget>[
      Text(
        'Index 0: Home',
        style: optionStyle,
      ),
      Text(
        'Index 1: Business',
        style: optionStyle,
      ),
      Text(
        'Index 2: School',
        style: optionStyle,
      ),
      Text(
        'Index 3: Map',
        style: optionStyle,
      ),
      Text(
        'Index 4: Video',
        style: optionStyle,
      ),
    ];
    _selectedIndex = 0;
  }
  _updateReduceNavs() {
    _navItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.business),
        title: Text('Business'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.school),
        title: Text('School'),
      ),
    ];
    _widgetOptions = <Widget>[
      Text(
        'Index 0: Home',
        style: optionStyle,
      ),
      Text(
        'Index 1: Business',
        style: optionStyle,
      ),
      Text(
        'Index 2: School',
        style: optionStyle,
      ),
    ];
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // HBottomNavPage.builder(
        //   appBar: AppBar(),
        //   currentIndex: _selectedIndex,
        //   onTap: (index) {
        //     _onItemTapped(index);
        //   },
        //   navChildContent: (index) {
        //     return Center(
        //       child: _widgetOptions[index],
        //     );
        //   },
        //   items: _navItems,
        //   type: BottomNavigationBarType.fixed,
        // ),
        Row(
          children: <Widget>[
            RaisedButton(
              child: Text("+"),
              onPressed: () {
                setState(() {
                  _updateAddNavs();
                });
              },
            ),
            RaisedButton(
              child: Text("-"),
              onPressed: () {
                setState(() {
                  _updateReduceNavs();
                });
              },
            )
          ],
        )
      ],
    );
  }
}
