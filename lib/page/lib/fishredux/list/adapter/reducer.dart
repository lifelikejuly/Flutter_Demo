
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/page/lib/fishredux/list/state.dart';

import 'action.dart';
import 'state.dart';

Reducer<DemoListAdapterState> buildReducer() {
  return asReducer(<Object, Reducer<DemoListAdapterState>>{
    SpecialShopItemAction.onUpdateItem: _update,
    SpecialShopItemAction.onChangeRelatedShops: _changeRelatedShops,
  });
}

DemoListAdapterState _update(DemoListAdapterState state, Action action) {
  DemoListAdapterState newState = state.clone();
  return newState;
}

DemoListAdapterState _changeRelatedShops(DemoListAdapterState state,Action action){
  return state;
}
