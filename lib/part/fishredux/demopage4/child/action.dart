import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/part/fishredux/demopage4/child/state.dart';

enum ChildAction {
  action,
  update,
}

class ChildActionCreator {
  static Action onAction(ChildState state) {
    return Action(ChildAction.action, payload: state);
  }

  static Action onUpdate(ChildState state) {
    return Action(ChildAction.update, payload: state);
  }
}
