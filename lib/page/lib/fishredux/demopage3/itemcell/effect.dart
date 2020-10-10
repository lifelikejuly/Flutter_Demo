import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<fishComponent1State> buildEffect() {
  return combineEffects(<Object, Effect<fishComponent1State>>{
    fishComponent1Action.action: _onAction,
  });
}

void _onAction(Action action, Context<fishComponent1State> ctx) {
}
