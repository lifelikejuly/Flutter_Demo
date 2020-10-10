import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../action.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    Demo1ChildViewState state, Dispatch dispatch, ViewService viewService) {
  print("childView buildView");
  return Container(
      color: Colors.yellow,
      child: Column(
        children: <Widget>[
          Text("子布局调用Action更新顶级视图"),
          Row(
            children: <Widget>[
              RaisedButton(
                child: Text("add"),
                onPressed: () {
                  dispatch(FishDemoPage1ActionCreator.onAddAction());
                },
              ),
              RaisedButton(
                child: Text("reduce"),
                onPressed: () {
                  dispatch(FishDemoPage1ActionCreator.onReduceAction());
                },
              ),
              Text("self num: ${state.childNum}"),
              RaisedButton(
                child: Text("self num add"),
                onPressed: () {
                  dispatch(Demo1ChildViewActionCreator.onUpdateSelfAction(
                      state.clone()..childNum += 1));
                },
              ),
            ],
          ),
        ],
      ));
}
