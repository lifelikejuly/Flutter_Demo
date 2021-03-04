import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/page/lib/fishredux/demopage1/childview/state.dart';

enum Demo1ChildViewAction {
  action,
  updateSelf,
  addSelf,
}

class Demo1ChildViewActionCreator {
  static Action onAction() {
    return const Action(Demo1ChildViewAction.action);
  }

  static Action onUpdateSelfAction(Demo1ChildViewState state) {
    return Action(Demo1ChildViewAction.updateSelf, payload: state);
  }
  static Action onAddSelfAction() {
    return Action(Demo1ChildViewAction.addSelf,);
  }
}
