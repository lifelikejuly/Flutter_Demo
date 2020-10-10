import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<masterPageState> buildEffect() {
  return combineEffects(<Object, Effect<masterPageState>>{
    masterPageAction.action: _onAction,
  });
}

void _onAction(Action action, Context<masterPageState> ctx) {
}
