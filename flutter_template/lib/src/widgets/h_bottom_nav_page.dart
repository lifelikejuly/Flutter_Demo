import 'package:flutter/material.dart';

typedef Widget NavChildContent(int currentIndex);

class HBottomNavPage extends StatelessWidget {
//  AppBottomNavPage({
//    Key key,
//    @required this.navChildContent,
//    this.items,
//    this.onTap,
//    this.currentIndex = 0,
//    this.elevation = 8.0,
//    BottomNavigationBarType type,
//    Color fixedColor,
//    this.backgroundColor,
//    this.iconSize = 24.0,
//    Color selectedItemColor,
//    this.unselectedItemColor,
//    this.selectedIconTheme = const IconThemeData(),
//    this.unselectedIconTheme = const IconThemeData(),
//    this.selectedFontSize = 14.0,
//    this.unselectedFontSize = 12.0,
//    this.selectedLabelStyle,
//    this.unselectedLabelStyle,
//    this.showSelectedLabels = true,
//    bool showUnselectedLabels,
//  })  : assert(items != null),
//        assert(items.length >= 2),
//        assert(
//          items.every((BottomNavigationBarItem item) => item.title != null) ==
//              true,
//          'Every item must have a non-null title',
//        ),
//        type = _type(type, items),
//        selectedItemColor = selectedItemColor ?? fixedColor,
//        showUnselectedLabels =
//            showUnselectedLabels ?? _defaultShowUnselected(_type(type, items)),
//        super(key: key);

  HBottomNavPage.builder({
    Key key,
    this.appBar,
    @required this.navChildContent,
    this.items,
    this.onTap,
    this.currentIndex = 0,
    this.elevation = 8.0,
    BottomNavigationBarType type,
    Color fixedColor,
    this.backgroundColor,
    this.iconSize = 24.0,
    Color selectedItemColor,
    this.unselectedItemColor,
    this.selectedIconTheme = const IconThemeData(),
    this.unselectedIconTheme = const IconThemeData(),
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 14.0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels = true,
    bool showUnselectedLabels,
  })  : assert(items != null),
        assert(items.length >= 2),
        assert(
          items.every((BottomNavigationBarItem item) => item.title != null) ==
              true,
          'Every item must have a non-null title',
        ),
        type = _type(type, items),
        selectedItemColor = selectedItemColor ?? fixedColor,
        showUnselectedLabels =
            showUnselectedLabels ?? _defaultShowUnselected(_type(type, items)),
        super(key: key);
  final PreferredSizeWidget appBar;
  final NavChildContent navChildContent;
  final List<BottomNavigationBarItem> items;
  final ValueChanged<int> onTap;
  final int currentIndex;
  final double elevation;
  final BottomNavigationBarType type;

  Color get fixedColor => selectedItemColor;
  final Color backgroundColor;
  final double iconSize;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final IconThemeData selectedIconTheme;
  final IconThemeData unselectedIconTheme;
  final TextStyle selectedLabelStyle;
  final TextStyle unselectedLabelStyle;
  final double selectedFontSize;
  final double unselectedFontSize;
  final bool showUnselectedLabels;
  final bool showSelectedLabels;

  static BottomNavigationBarType _type(
    BottomNavigationBarType type,
    List<BottomNavigationBarItem> items,
  ) {
    if (type != null) {
      return type;
    }
    return items.length <= 3
        ? BottomNavigationBarType.fixed
        : BottomNavigationBarType.shifting;
  }

  static bool _defaultShowUnselected(BottomNavigationBarType type) {
    switch (type) {
      case BottomNavigationBarType.shifting:
        return false;
      case BottomNavigationBarType.fixed:
        return true;
    }
    assert(false);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: navChildContent(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        onTap: onTap,
        currentIndex: currentIndex,
        elevation: elevation,
        type: type,
        fixedColor: fixedColor,
        backgroundColor: backgroundColor,
        iconSize: iconSize,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        selectedIconTheme: selectedIconTheme,
        unselectedIconTheme: unselectedIconTheme,
        selectedFontSize: selectedFontSize,
        unselectedFontSize: unselectedFontSize,
        selectedLabelStyle: selectedLabelStyle,
        unselectedLabelStyle: unselectedLabelStyle,
        showSelectedLabels: showSelectedLabels,
      ),
    );
  }
}
