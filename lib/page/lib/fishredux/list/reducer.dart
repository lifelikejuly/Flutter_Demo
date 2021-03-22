import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<DemoListAdapterState> buildReducer() {
  return asReducer(
    <Object, Reducer<DemoListAdapterState>>{
      DemoListAdapterAction.action: _onAction,
    },
  );
}

DemoListAdapterState _onAction(DemoListAdapterState state, Action action) {
  final DemoListAdapterState newState = state.clone();
  return newState;
}
