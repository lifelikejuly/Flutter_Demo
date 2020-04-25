import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'list/state.dart';
import 'state.dart';

Effect<fishListState> buildEffect() {
  return combineEffects(<Object, Effect<fishListState>>{
    Lifecycle.initState: _init,
    FishDemoListPageAction.action: _onAction,
  });
}

void _onAction(Action action, Context<fishListState> ctx) {
}

void _init(Action action, Context<fishListState> ctx){
  print("fishdemepage3State _init");
  ctx.dispatch(FishDemoListPageActionCreator.onLoadData());
}

