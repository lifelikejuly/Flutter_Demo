import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';
// state 状态数据 dispatch 分发action

Widget buildView(
    FishDemoPage1State state, Dispatch dispatch, ViewService viewService) {
  print("<>  --- fishPage1 Scaffold buildView");
  return _buildView(state, dispatch, viewService);
//  return Scaffold(
//    appBar: AppBar(),
//    body: Container(
//      child: Column(
//        children: <Widget>[
//          Text("page1 ${state.total}"),
//          Row(
//            children: <Widget>[
//              RaisedButton(
//                child: Text("add"),
//                onPressed: () {
//                  dispatch(FishDemoPage1ActionCreator.onAddAction());
//                },
//              ),
//              RaisedButton(
//                child: Text("reduce"),
//                onPressed: () {
//                  dispatch(FishDemoPage1ActionCreator.onReduceAction());
//                },
//              ),
//            ],
//          ),
//
//          /// 直接通知reducer 会不更新UI
//          Row(
//            children: <Widget>[
//              RaisedButton(
//                child: Text("new add"),
//                onPressed: () {
//                  dispatch(FishDemoPage1ActionCreator.changeNumState(
//                      state..total += 1));
//                },
//              ),
//              RaisedButton(
//                child: Text("new reduce"),
//                onPressed: () {
//                  dispatch(FishDemoPage1ActionCreator.changeNumState(
//                      state..total -= 1));
//                },
//              ),
//            ],
//          ),
//          RaisedButton(
//            child: Text("GotoPage2"),
//            onPressed: () {
//              dispatch(FishDemoPage1ActionCreator.goToPage2());
//            },
//          ),
//          viewService.buildComponent("child"),
//        ],
//      ),
//    ),
//  );
}

class _buildView extends StatefulWidget {
  FishDemoPage1State state;
  Dispatch dispatch;
  ViewService viewService;

  _buildView(this.state, this.dispatch, this.viewService);

  @override
  __buildViewState createState() => __buildViewState();
}

class __buildViewState extends State<_buildView> {
  FishDemoPage1State get state => widget.state;

  Dispatch get dispatch => widget.dispatch;

  ViewService get viewService => widget.viewService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Text("page1 ${state.total}"),
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
              ],
            ),

            /// 直接通知reducer 会不更新UI
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("new add"),
                  onPressed: () {
                    dispatch(FishDemoPage1ActionCreator.changeNumState(
                        state..total += 1));
                  },
                ),
                RaisedButton(
                  child: Text("new reduce"),
                  onPressed: () {
                    dispatch(FishDemoPage1ActionCreator.changeNumState(
                        state..total -= 1));
                  },
                ),
              ],
            ),
            RaisedButton(
              child: Text("GotoPage2"),
              onPressed: () {
                dispatch(FishDemoPage1ActionCreator.goToPage2());
              },
            ),
            viewService.buildComponent("child"),
          ],
        ),
      ),
    );
  }
}
