import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ChildState> buildReducer() {
  return asReducer(
    <Object, Reducer<ChildState>>{
      ChildAction.update: _onUpdate,
    },
  );
}

ChildState _onUpdate(ChildState state, Action action) {
  final ChildState newState = action.payload;
  println("ReduxData child _onUpdate newState ${newState.child1Num}");
  return newState;
}
