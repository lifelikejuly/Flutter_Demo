import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<fishComponent1State> buildReducer() {
  return asReducer(
    <Object, Reducer<fishComponent1State>>{
      fishComponent1Action.action: _onAction,
    },
  );
}

fishComponent1State _onAction(fishComponent1State state, Action action) {
  final fishComponent1State newState = state.clone();
  return newState;
}
