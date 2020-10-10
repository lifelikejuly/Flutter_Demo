import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum FishDemoListPageAction { action ,loadData}

class FishDemoListPageActionCreator {
  static Action onAction() {
    return const Action(FishDemoListPageAction.action);
  }
  static Action onLoadData(){
    return const Action(FishDemoListPageAction.loadData);
  }
}
