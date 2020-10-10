import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<Demo1ChildViewState> buildEffect() {
  return combineEffects(<Object, Effect<Demo1ChildViewState>>{
    Demo1ChildViewAction.action: _onAction,
  });
}

void _onAction(Action action, Context<Demo1ChildViewState> ctx) {
}
