import 'package:flutter/material.dart';

class RouterDataDemo extends StatefulWidget {
  @override
  _RouterDataDemoState createState() => _RouterDataDemoState();
}

class _RouterDataDemoState extends State<RouterDataDemo> {
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text("RouterDataDemo"),
          Text("result $result"),
          RaisedButton(
            child: Text("pushNamed data2 with data = Hello "),
            onPressed: () async {
              Navigator.of(context).pushNamed(
                "/router/data2",
                arguments: {"data": "Hello"},
              );
            },
          ),
          RaisedButton(
            child: Text("push data3 with data = Hello "),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChildDateDemo3("Hello"),
                ),
              );
            },
          ),
          RaisedButton(
            child: Text("push data4 with data = Hello "),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChildDataDemo4(),
                  settings: RouteSettings(
                    arguments: {"data": "Hello"},
                  ),
                ),
              );
            },
          ),
          RaisedButton(
            child: Text("push data5 with data = Hello "),
            onPressed: () async {
              var result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChildDataDemo5(),
                ),
              );
              setState(() {
                this.result = result.toString();
              });
            },
          ),
        ],
      ),
    );
  }
}

class RouterChildDateDemo2 extends StatefulWidget {
  @override
  _RouterChildDateDemo2State createState() => _RouterChildDateDemo2State();
}

class _RouterChildDateDemo2State extends State<RouterChildDateDemo2> {
  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments;
    String data = arguments['data'];
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text("data: $data"),
        ],
      ),
    );
  }
}

class ChildDateDemo3 extends StatefulWidget {
  final String data;

  ChildDateDemo3(this.data);

  @override
  _ChildDateDemo3State createState() => _ChildDateDemo3State();
}

class _ChildDateDemo3State extends State<ChildDateDemo3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text("data: ${widget.data}"),
        ],
      ),
    );
  }
}

class ChildDataDemo4 extends StatefulWidget {
  @override
  _ChildDataDemo4State createState() => _ChildDataDemo4State();
}

class _ChildDataDemo4State extends State<ChildDataDemo4> {
  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments;
    String data = arguments['data'];
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text("data: $data"),
        ],
      ),
    );
  }
}

class ChildDataDemo5 extends StatefulWidget {
  @override
  _ChildDataDemo5State createState() => _ChildDataDemo5State();
}

class _ChildDataDemo5State extends State<ChildDataDemo5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("pop with data = Bye "),
            onPressed: () async {
              Navigator.of(context).pop({"data": "Bye"});
            },
          ),
        ],
      ),
    );
    ;
  }
}
