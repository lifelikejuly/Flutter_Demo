import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(ChildState state, Dispatch dispatch, ViewService viewService) {
  return _ChildCell(state, dispatch, viewService);
}

class _ChildCell extends StatelessWidget {
  final ChildState state;
  final Dispatch dispatch;
  final ViewService viewService;

  _ChildCell(this.state, this.dispatch, this.viewService);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text("${state.child1Num}"),
          RaisedButton(
            child: Text("++"),
            onPressed: () {
              ChildState newState = state.clone();
              newState.child1Num = state.child1Num + 1;
              dispatch(ChildActionCreator.onUpdate(newState));
            },
          ),
          RaisedButton(
            child: Text("--"),
            onPressed: () {
              ChildState newState = state.clone();
              newState.child1Num = state.child1Num - 1;
              dispatch(ChildActionCreator.onUpdate(newState));
            },
          )
        ],
      ),
    );
  }
}
