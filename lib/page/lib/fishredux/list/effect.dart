import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<DemoListAdapterState> buildEffect() {
  return combineEffects(<Object, Effect<DemoListAdapterState>>{
    DemoListAdapterAction.action: _onAction,
  });
}

void _onAction(Action action, Context<DemoListAdapterState> ctx) {
}
