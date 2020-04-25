import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum fishComponent1Action { action }

class fishComponent1ActionCreator {
  static Action onAction() {
    return const Action(fishComponent1Action.action);
  }
}
