import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<SpecialShopRelatedItemState> buildEffect() {
  return combineEffects(<Object, Effect<SpecialShopRelatedItemState>>{
    SpecialShopRelatedItemAction.changeShops: _onChangeShop,
  });
}

void _onChangeShop(Action action, Context<SpecialShopRelatedItemState> ctx) {
  SpecialShopRelatedItemState data = action.payload;
  data.listIndex = data.listIndex + 1;
  ctx.dispatch(SpecialShopRelatedItemActionCreator.onUpdate(data));
}
