import 'package:fish_redux/fish_redux.dart';

// 要做的操作在这里定义
//TODO replace with your own action
enum FishDemoPage1Action { add, reduce, actionAdd,actionReduce, Next }

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
}
