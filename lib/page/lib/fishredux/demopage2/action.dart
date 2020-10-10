import 'package:fish_redux/fish_redux.dart';

import 'FishModel.dart';
//TODO replace with your own action
enum fishdemepage2Action { action, actionAsync, loadData, loadDataAsync }

class fishdemepage2ActionCreator {
  static Action onAction() {
    return const Action(fishdemepage2Action.action);
  }

  static Action onActionAsync() {
    return const Action(fishdemepage2Action.actionAsync);
  }

  static Action onLoadData() {
    return const Action(fishdemepage2Action.loadData);
  }

  static Action onLoadDataAsync(List<FishModel> list) {
    return  Action(fishdemepage2Action.loadDataAsync, payload: list);
  }
}
