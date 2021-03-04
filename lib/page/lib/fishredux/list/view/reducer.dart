
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SpecialShopRelatedItemState> buildReducer() {
  return asReducer(<Object, Reducer<SpecialShopRelatedItemState>>{
    SpecialShopRelatedItemAction.updateState: _onUpdate,
  });
}

SpecialShopRelatedItemState _onUpdate(SpecialShopRelatedItemState state,Action action){
  SpecialShopRelatedItemState data = action.payload;
  if(state.index == data.index){
    SpecialShopRelatedItemState newState = state.clone();
    newState.listIndex = data.listIndex;
    print("<> _onUpdate (state.listIndex ${state.listIndex} == data.listIndex ${data.listIndex}");
    return newState;
    // state.listIndex = data.listIndex;
    // print("<> _onUpdate (state.listIndex ${state.listIndex} == data.listIndex ${data.listIndex}");
    // return state;
  }
  return state;
}
