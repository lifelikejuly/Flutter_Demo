import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<HeaderViewState> buildReducer() {
  return asReducer(
    <Object, Reducer<HeaderViewState>>{
      HeaderViewAction.action: _onAction,
    },
  );
}

HeaderViewState _onAction(HeaderViewState state, Action action) {
  final HeaderViewState newState = state.clone();
  return newState;
}
