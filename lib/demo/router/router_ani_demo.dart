import 'package:flutter/material.dart';

class RouterDAniDemo extends StatefulWidget {
  @override
  _RouterDAniDemoState createState() => _RouterDAniDemoState();
}

class _RouterDAniDemoState extends State<RouterDAniDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("push AniDemo2"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AniDemo2(),
                ),
              );
            },
          ),
          RaisedButton(
            child: Text(""),
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation1,
                      Animation<double> animation2) {
                    return AniDemo2();
                  },
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation1,
                      Animation<double> animation2,
                      Widget child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(-1.0, 0.0),
                        end: Offset(0.0, 0.0),
                      ).animate(
                        animation1,
                      ),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
          RaisedButton(
            child: Text("push "),
            onPressed: () {
              Navigator.of(context).push(
                CustomerPageRouteBuilder(
                  AniDemo2(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AniDemo2 extends StatefulWidget {
  @override
  _AniDemo2State createState() => _AniDemo2State();
}

class _AniDemo2State extends State<AniDemo2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.blueAccent,
        width: double.infinity,
        height: double.infinity,
        child: Text("sss"),
      ),
    );
  }
}

class CustomerPageRouteBuilder extends PageRouteBuilder {
  final Widget widget;

  CustomerPageRouteBuilder(this.widget)
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation1,
              Animation<double> animation2) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation1,
              Animation<double> animation2,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(-1.0, 0.0),
                end: Offset(0.0, 0.0),
              ).animate(
                CurvedAnimation(
                  parent: animation1,
                  curve: Curves.fastOutSlowIn,
                ),
              ),
              child: child,
            );
          },
        );
}
