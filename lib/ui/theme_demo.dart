import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeDemo extends StatefulWidget {
  @override
  _ThemeDemoState createState() => _ThemeDemoState();
}

class _ThemeDemoState extends State<ThemeDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("正常"),
            onPressed: () {
              Provider.of<ThemeNotifier>(context).lightTheme();
            },
          ),
          RaisedButton(
            child: Text("夜间"),
            onPressed: () {
              Provider.of<ThemeNotifier>(context).darkTheme();
            },
          )
        ],
      ),
    );
  }
}

class ThemeNotifier with ChangeNotifier {
  bool dark = false;

  bool get isDark => dark;

  void darkTheme() {
    dark = true;
    notifyListeners();
  }

  void lightTheme() {
    dark = false;
    notifyListeners();
  }
}
