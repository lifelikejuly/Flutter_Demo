import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<fishdemepage2State> buildEffect() {
  return combineEffects(<Object, Effect<fishdemepage2State>>{
    Lifecycle.initState: _init,
    fishdemepage2Action.action: _onAction,
  });
}

void _onAction(Action action, Context<fishdemepage2State> ctx) {
}

void _init(Action action, Context<fishdemepage2State> ctx){
  print("fishdemepage2State _init");
  ctx.dispatch(fishdemepage2ActionCreator.onLoadData());
}
