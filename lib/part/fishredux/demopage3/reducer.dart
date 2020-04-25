import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/part/fishredux/demopage3/itemcell/state.dart';
import 'package:flutter_demo/part/fishredux/demopage3/list/state.dart';

import 'action.dart';
import 'state.dart';

Reducer<fishListState> buildReducer() {
  return asReducer(
    <Object, Reducer<fishListState>>{
      FishDemoListPageAction.action: _onAction,
      FishDemoListPageAction.loadData: _onLoadData,
    },
  );
}

fishListState _onAction(fishListState state, Action action) {
  final fishListState newState = state.clone();
  return newState;
}

fishListState _onLoadData(fishListState state, Action action) {
  print("fishdemepage3State _onLoadData");
  List<fishComponent1State> items = List();
  items.add(fishComponent1State(name: "aaa", sex: "man", num: 1));
  items.add(fishComponent1State(name: "bbb", sex: "man", num: 2));
  items.add(fishComponent1State(name: "ccc", sex: "woman", num: 3));
  items.add(fishComponent1State(name: "ddd", sex: "man", num: 4));
  items.add(fishComponent1State(name: "eee", sex: "woman", num: 5));
  items.add(fishComponent1State(name: "fff", sex: "man", num: 6));
  items.add(fishComponent1State(name: "ggg", sex: "woman", num: 7));
  final fishListState newState = state.clone()..items.addAll(items);
  return newState;
}
