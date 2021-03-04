import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

enum SpecialShopRelatedItemAction {
  changeShops,
  updateState
}

class SpecialShopRelatedItemActionCreator {
  static Action onChangeShops(SpecialShopRelatedItemState state) {
    return Action(SpecialShopRelatedItemAction.changeShops, payload: state);
  }
  static Action onUpdate(SpecialShopRelatedItemState state) {
    return Action(SpecialShopRelatedItemAction.updateState,payload: state);
  }
}
