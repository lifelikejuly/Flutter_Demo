import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum mainAction { action }

class mainActionCreator {
  static Action onAction() {
    return const Action(mainAction.action);
  }
}
