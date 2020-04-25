import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;
import 'action.dart';
import 'state.dart';
//dispatch做action 先执行这里
Effect<FishDemoPage1State> buildEffect() {
  return combineEffects(<Object, Effect<FishDemoPage1State>>{
    FishDemoPage1Action.add: _onAddAction,
    FishDemoPage1Action.reduce: _onReduceAction,
    FishDemoPage1Action.Next: _gotoPage,
  });
}

void _onAddAction(Action action, Context<FishDemoPage1State> ctx) {
  print("buildEffect _onAction");
  ctx.dispatch(Action(FishDemoPage1Action.actionAdd));
}

void _onReduceAction(Action action, Context<FishDemoPage1State> ctx) {
  print("buildEffect _onAction");
  ctx.dispatch(Action(FishDemoPage1Action.actionReduce));
}

void _gotoPage(Action action, Context<FishDemoPage1State> ctx) {
  print("buildEffect _gotoPage2");
  Navigator.of(ctx.context).pushNamed('fishPage2'); //注意2
}
