import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum fishListAction { action }

class fishListActionCreator {
  static Action onAction() {
    return const Action(fishListAction.action);
  }
}
