import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum DemoListAdapterAction { action }

class DemoListAdapterActionCreator {
  static Action onAction() {
    return const Action(DemoListAdapterAction.action);
  }
}
