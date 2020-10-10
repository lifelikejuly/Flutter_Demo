import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<ChildState> buildEffect() {
  return combineEffects(<Object, Effect<ChildState>>{
    ChildAction.action: _onAction,
  });
}

void _onAction(Action action, Context<ChildState> ctx) {
//  ctx.dispatch(ChildActionCreator.onUpdate(action.payload));
}
