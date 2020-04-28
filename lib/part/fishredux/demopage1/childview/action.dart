import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum Demo1ChildViewAction { action }

class Demo1ChildViewActionCreator {
  static Action onAction() {
    return const Action(Demo1ChildViewAction.action);
  }
}
