import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<Demo1ChildViewState> buildReducer() {
  return asReducer(
    <Object, Reducer<Demo1ChildViewState>>{
      Demo1ChildViewAction.action: _onAction,
      Demo1ChildViewAction.updateSelf: _onUpdateSelf,
      Demo1ChildViewAction.addSelf: _onAddSelf,
    },
  );
}

Demo1ChildViewState _onAction(Demo1ChildViewState state, Action action) {
  final Demo1ChildViewState newState = state.clone();
  return newState;
}

Demo1ChildViewState _onUpdateSelf(Demo1ChildViewState state, Action action) {
  Demo1ChildViewState newState = action.payload;
  print("<> _onUpdateSelf ${newState.childNum}");
  state.childNum = newState.childNum;
  return state;
}

Demo1ChildViewState _onAddSelf(Demo1ChildViewState state, Action action) {
  Demo1ChildViewState newState = state.clone();
  newState.childNum++;
  return newState;
}
