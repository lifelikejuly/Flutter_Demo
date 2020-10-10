import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<mainState> buildReducer() {
  return asReducer(
    <Object, Reducer<mainState>>{
      mainAction.action: _onAction,
    },
  );
}

mainState _onAction(mainState state, Action action) {
  final mainState newState = state.clone();
  return newState;
}
