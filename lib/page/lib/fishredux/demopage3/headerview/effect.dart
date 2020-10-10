import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<HeaderViewState> buildEffect() {
  return combineEffects(<Object, Effect<HeaderViewState>>{
    HeaderViewAction.action: _onAction,
  });
}

void _onAction(Action action, Context<HeaderViewState> ctx) {
}
