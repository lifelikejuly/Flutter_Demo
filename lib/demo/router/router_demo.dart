import 'package:flutter/material.dart';
import 'package:flutter_demo/main.dart';

class RouterDemo extends StatefulWidget {
  @override
  _RouterDemoState createState() => _RouterDemoState();
}

class _RouterDemoState extends State<RouterDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("push NextPage1"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NextPage1(),
                ),
              );
            },
          ),
          RaisedButton(
            child: Text("push NextPage1 by RouteSettings"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => NextPage1(),
                    settings: RouteSettings(name: "NextPage1")),
              );
            },
          ),
          RaisedButton(
            child: Text("pushNamed NextPage1"),
            onPressed: () {
              Navigator.of(context).pushNamed("/router/next1");
            },
          ),
          RaisedButton(
            child: Text("pushNamed next2"),
            onPressed: () {
              Navigator.of(context).pushNamed("/router/next2");
            },
          ),
          RaisedButton(
            child: Text("popAndPushNamed next2"),
            onPressed: () {
              Navigator.of(context).popAndPushNamed("/router/next2");
            },
          ),
          RaisedButton(
            child: Text("pop"),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).maybePop();
            },
          ),
        ],
      ),
    );
  }
}

class NextPage1 extends StatefulWidget {
  @override
  _NextPage1State createState() => _NextPage1State();
}

class _NextPage1State extends State<NextPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("push next1"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NextPage1(),
                ),
              );
            },
          ),
          RaisedButton(
            child: Text("pushNamed next1"),
            onPressed: () {
              Navigator.of(context).pushNamed("/router/next1");
            },
          ),
          RaisedButton(
            child: Text("pushNamed next1 rootNavigator"),
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed("/router/next1");
            },
          ),
          RaisedButton(
            child: Text("pushNamed next2"),
            onPressed: () {
              Navigator.of(context).pushNamed("/router/next2");
            },
          ),
          RaisedButton(
            child: Text("pushReplacementNamed next2"),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/router/next2");
            },
          ),
//          RaisedButton(
//            child: Text("removeRoute"),
//            onPressed: () {
//              Navigator.of(context).removeRoute(MaterialPageRoute(builder: (BuildContext context) => NextPage1()));
//            },
//          ),
        ],
      ),
    );
  }
}

class NextPage2 extends StatefulWidget {
  @override
  _NextPage2State createState() => _NextPage2State();
}

class _NextPage2State extends State<NextPage2> {
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text("Next2"),
          Text("result $result"),
          RaisedButton(
            child: Text("next3"),
            onPressed: () {
              Navigator.of(context).pushNamed("/router/next3");
            },
          ),
          RaisedButton(
            child: Text("popUntil /"),
            onPressed: () {
              Navigator.of(context).popUntil(ModalRoute.withName("/"));
            },
          ),
          RaisedButton(
            child: Text("pushReplacementNamed 5"),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/router/next5");
            },
          ),
          RaisedButton(
            child: Text("pop  push 5"),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NextPage5(),
                ),
              );
            },
          ),
          RaisedButton(
            child: Text("push next1"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NextPage1(),
                ),
              );
            },
          ),
          RaisedButton(
            child: Text("popAndPushNamed 5"),
            onPressed: () {
              Navigator.of(context).popAndPushNamed("/router/next5");
            },
          ),
          RaisedButton(
            child: Text("pushNamedAndRemoveUntil next5 /"),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                "/router/next5",
                ModalRoute.withName("/"),
              );
            },
          ),
          RaisedButton(
            child: Text("pushNamedAndRemoveUntil next5 next1"),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                "/router/next5",
                ModalRoute.withName("/router/next1"),
              );
            },
          ),
          RaisedButton(
            child: Text("pushNamed next4 with data "),
            onPressed: () async {
              var result = await Navigator.of(context)
                  .pushNamed("/router/next4", arguments: {"data": "Hello"});
              print("result $result");
              setState(() {
                this.result = result.toString();
              });
            },
          ),
          RaisedButton(
            child: Text("removeRoute this"),
            onPressed: () {
              Navigator.of(context).removeRoute(ModalRoute.of(context));
            },
          ),
          RaisedButton(
            child: Text("removeRouteBelow this"),
            onPressed: () {
              Navigator.of(context).removeRouteBelow(ModalRoute.of(context));
            },
          ),
          RaisedButton(
            child: Text("replace before to  NextPage1"),
            onPressed: () {
              Navigator.of(context).replace(
                oldRoute: UserNavigatorObserver
                    .history[UserNavigatorObserver.history.length - 2],
                newRoute: MaterialPageRoute(
                  builder: (_) => NextPage1(),
                ),
              );
            },
          ),
          RaisedButton(
            child: Text("replace beforeBelow to  NextPage1"),
            onPressed: () {
              Navigator.of(context).replaceRouteBelow(
                anchorRoute: UserNavigatorObserver
                    .history[UserNavigatorObserver.history.length - 2],
                newRoute: MaterialPageRoute(
                  builder: (_) => NextPage1(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class NextPage3 extends StatefulWidget {
  @override
  _NextPage3State createState() => _NextPage3State();
}

class _NextPage3State extends State<NextPage3> {
  bool onWillPop = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WillPopScope(
          child: Column(
            children: <Widget>[
              Text("Next3"),
              RaisedButton(
                child: Text("Next2"),
                onPressed: () {
                  Navigator.of(context).pushNamed("/router/next2");
                },
              ),
              RaisedButton(
                child: Text("maybePop"),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
              RaisedButton(
                child: Text("pop"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                child: Text("onWillPop $onWillPop"),
                onPressed: () {
                  setState(() {
                    onWillPop = !onWillPop;
                  });
                },
              ),
            ],
          ),
          onWillPop: () {
            return Future.value(onWillPop);
          }),
    );
  }
}

class NextPage4 extends StatefulWidget {
  @override
  _NextPage4State createState() => _NextPage4State();
}

class _NextPage4State extends State<NextPage4> {
  var uid;

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments;
    uid = arguments['data'];
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text("Next4"),
          Text("uid $uid"),
          RaisedButton(
            child: Text("uid $uid"),
            onPressed: () {
              setState(() {
                uid += "1";
              });
            },
          ),
          RaisedButton(
            child: Text("pop"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          RaisedButton(
            child: Text("pop with data: Bye"),
            onPressed: () {
              Navigator.of(context).pop({"data": "Bye"});
            },
          ),
          RaisedButton(
            child: Text("showLicensePage"),
            onPressed: () {
              showLicensePage(context: context);
            },
          )
        ],
      ),
    );
  }
}

class NextPage5 extends StatefulWidget {
  @override
  _NextPage5State createState() => _NextPage5State();
}

class _NextPage5State extends State<NextPage5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text("Next5"),
    );
  }
}
