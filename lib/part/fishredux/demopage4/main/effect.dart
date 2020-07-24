import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<mainState> buildEffect() {
  return combineEffects(<Object, Effect<mainState>>{
    mainAction.action: _onAction,
  });
}

void _onAction(Action action, Context<mainState> ctx) {
}
