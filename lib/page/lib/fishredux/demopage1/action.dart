import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/page/lib/fishredux/demopage1/state.dart';

// 要做的操作在这里定义
//TODO replace with your own action
enum FishDemoPage1Action {
  updateState,
  add,
  reduce,
  actionAdd,
  actionReduce,
  Next,
  changeNum,
}

class FishDemoPage1ActionCreator {
  static Action onAddAction() {
    print("onAction");
    return const Action(FishDemoPage1Action.add);
  }

  static Action onReduceAction() {
    print("onAction");
    return const Action(FishDemoPage1Action.reduce);
  }

  static Action goToPage2() {
    print("onAction goToPage2");
    return const Action(FishDemoPage1Action.Next);
  }

  static Action updateState(FishDemoPage1State page1state) {
    return Action(FishDemoPage1Action.updateState, payload: page1state);
  }

  static Action changeNumState(FishDemoPage1State state){
    return Action(FishDemoPage1Action.updateState,payload: state);
  }
}
