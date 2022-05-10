import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

final String TAG = "StatefulLifecycleDemo";
final String TAG2 = "ChildStatefulLifecycleDemo";

class StatefulLifecycleDemo extends StatefulWidget {
  @override
  _StatefulLifecycleDemoState createState() {
    print("$TAG  createState");
    return _StatefulLifecycleDemoState();
  }

  StatefulLifecycleDemo() {
    print("$TAG  constructor");
  }
}

class _StatefulLifecycleDemoState extends State<StatefulLifecycleDemo> {
  NumModel numModel;
  bool show = false;

  List<String> logs = [];

  @override
  Widget build(BuildContext context) {
    print("$TAG  build");
    _addLogOnly("$TAG  build");
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Text("${numModel.num}"),
            RaisedButton(
              child: Text("text"),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => NextPage2()));
              },
            ),
            RaisedButton(
              child: Text("add"),
              onPressed: () {
                setState(() {
                  numModel.num += 1;
                });
              },
            ),
//            ShareWidget(
//              data: show,
//              child: ChildWidget(numModel),
//            ),
            ChildWidget(numModel),
            RaisedButton(
              child: Text("add"),
              onPressed: () {
                setState(() {
                  show = !show;
                });
              },
            ),
//            Expanded(
//              child: ListView.builder(
//                itemBuilder: (context, item) {
//                  return Text(logs[item]);
//                },
//                itemCount: logs.length,
//              ),
//            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    numModel = NumModel(0);
    print("$TAG  initState");
    _addLogs("$TAG  initState");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      print("$TAG  SchedulerBinding");
      _addLogs("$TAG  SchedulerBinding");
    });
  }

  @override
  void setState(fn) {
    print("$TAG  setState");
//    _addLogs("$TAG StatefulLifecycleDemo setState");
    super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    print("$TAG  dispose");
//    _addLogs("$TAG StatefulLifecycleDemo dispose");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("$TAG  didChangeDependencies");
    _addLogs("$TAG  didChangeDependencies");
  }

  @override
  void deactivate() {
//    _addLogs("$TAG StatefulLifecycleDemo deactivate");
    super.deactivate();
  }

  @override
  void didUpdateWidget(StatefulLifecycleDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("$TAG  didUpdateWidget");
    _addLogs("$TAG  didUpdateWidget");
  }

  @override
  void reassemble() {
    super.reassemble();
    print("$TAG  reassemble");
    _addLogs("$TAG  reassemble");
  }

  _addLogs(String log) {
//    logs.add(log);
//    setState(() {
//
//    });
  }

  _addLogOnly(String log) {
//    logs.add(log);
  }
}

class NumModel {
  int num;

  NumModel(this.num);
}

class ShareWidget extends InheritedWidget {
  bool data;

  ShareWidget({@required this.data, Widget child}) : super(child: child);

  //定义一个方法，方便子树中的widget获取这个widget，进而获得共享数据。
  static ShareWidget of(BuildContext context) {
    /**
     * 获取最近的给定类型的Widget，该widget必须是InheritedWidget的子类，
     * 并向该widget注册传入的context，当该widget改变时，
     * 这个context会重新构建以便从该widget获得新的值。
     * 这就是child向InheritedWidget注册的方法。
     */
    return context.findAncestorRenderObjectOfType();
  }

  /**
   * framework通过使用以前占据树中的这个位置的小部件作为参数调用这个函数来区分这些情况。
   */
  @override
  bool updateShouldNotify(ShareWidget oldWidget) {
    return oldWidget.data != data;
  }
}

class ChildWidget extends StatefulWidget {
  NumModel num;

  ChildWidget(this.num);

  @override
  _ChildWidgetState createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text("${widget.num.num}"),
          Text(ShareWidget.of(context)?.data?.toString() ?? ""),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(ChildWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print(
        "$TAG2 ChildWidget didUpdateWidget ${oldWidget.num.num} ${widget.num.num}");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("$TAG2 ChildWidget didChangeDependencies");
  }

//
//  @override
//  void didUpdateWidget(StatefulLifecycleDemo oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    print("$TAG2 ChildWidget didUpdateWidget");
//  }
}

class NextPage2 extends StatefulWidget {
  @override
  _NextPage2State createState() => _NextPage2State();
}

class _NextPage2State extends State<NextPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text("hahah"),
      ),
    );
  }
}

class NextPage extends StatefulWidget {
  NumModel num;

  NextPage(this.num);

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("${widget.num.num}"),
              onPressed: () {
                setState(() {
                  widget.num.num += 1;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
