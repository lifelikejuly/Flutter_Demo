import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';
//在effect之后接收action的做state数据变化操作
Reducer<FishDemoPage1State> buildReducer() {

  return asReducer(
    <Object, Reducer<FishDemoPage1State>>{
      FishDemoPage1Action.actionAdd: _onAddAction,
      FishDemoPage1Action.actionReduce: _onReduceAction,
      FishDemoPage1Action.updateState: _onUpdateAction,
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

FishDemoPage1State _onUpdateAction(FishDemoPage1State state, Action action){
  final FishDemoPage1State newState = action.payload;
  print("buildReducer _onUpdateAction ${state.total}");
  return newState;
}
