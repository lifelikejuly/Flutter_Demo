import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum fishdemepage2Action { action,loadData }

class fishdemepage2ActionCreator {
  static Action onAction() {
    return const Action(fishdemepage2Action.action);
  }

  static Action onLoadData(){
    return const Action(fishdemepage2Action.loadData);
  }
}
