import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/page/lib/fishredux/list/view/state.dart';

enum SpecialShopItemAction {
  onUpdateItem,
  onChangeRelatedShops,
}

class SpecialShopActionCreator {

  static Action onChangeRelatedShops(SpecialShopRelatedItemState state) {
    return Action(SpecialShopItemAction.onChangeRelatedShops, payload: state);
  }
}
