import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<masterPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<masterPageState>>{
      masterPageAction.action: _onAction,
    },
  );
}

masterPageState _onAction(masterPageState state, Action action) {
  final masterPageState newState = state.clone();
  return newState;
}
