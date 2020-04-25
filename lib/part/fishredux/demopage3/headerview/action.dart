import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum HeaderViewAction { action }

class HeaderViewActionCreator {
  static Action onAction() {
    return const Action(HeaderViewAction.action);
  }
}
