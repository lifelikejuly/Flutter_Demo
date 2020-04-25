import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/part/fishredux/demopage1/page.dart';


class FishReduxDemo extends StatefulWidget {
  @override
  _FishReduxDemoState createState() => _FishReduxDemoState();
}

class _FishReduxDemoState extends State<FishReduxDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("FishPage1"),
              onPressed: () {
                Navigator.of(context).pushNamed('fishPage1');
              },
            ),
            RaisedButton(
              child: Text("FishPage2"),
              onPressed: () {
                Navigator.of(context).pushNamed('fishPage2');
              },
            ),
            RaisedButton(
              child: Text("FishPage3Component"),
              onPressed: () {
                Navigator.of(context).pushNamed('fishPage3');
              },
            )
          ],
        ),
      ),
    );
  }
}
/**
 *  page是整体组成部分
 *  state是数据状态管理
 *  action 制定操作指令
 *  effect 首先响应dispatch的action
 *  reducer 对应执行的action做相应state更新操作
 *  view负责UI展示
 *  Component是粒度更细的page 将各个视图划分成更小
 *
 *
 *
 */