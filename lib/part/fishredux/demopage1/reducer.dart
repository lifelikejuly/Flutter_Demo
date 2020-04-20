import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<FishDemoPage1State> buildReducer() {
  return asReducer(
    <Object, Reducer<FishDemoPage1State>>{
      FishDemoPage1Action.actionAdd: _onAddAction,
      FishDemoPage1Action.actionReduce: _onReduceAction,
    },
  );
}

FishDemoPage1State _onAddAction(FishDemoPage1State state, Action action) {
  final FishDemoPage1State newState = state.clone();
  print("buildReducer _onAddAction");
  newState.total += 1;
  return newState;
}

FishDemoPage1State _onReduceAction(FishDemoPage1State state, Action action) {
  final FishDemoPage1State newState = state.clone();
  print("buildReducer _onReduceAction");
  newState.total -= 1;
  return newState;
}
