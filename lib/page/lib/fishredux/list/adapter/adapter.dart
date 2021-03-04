import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/page/lib/fishredux/list/state.dart';
import 'package:flutter_demo/page/lib/fishredux/list/view/component.dart';
import 'package:flutter_demo/page/lib/fishredux/list/view/state.dart';

import 'state.dart';
import 'reducer.dart';

class FollowSpecialShopAdapter
    extends SourceFlowAdapter<DemoListAdapterState> {
  FollowSpecialShopAdapter()
      : super(
          pool: <String, Component>{
            "specialShopRelated": SpecialShopRelatedItemComponent(),
          },
          reducer: buildReducer(),
        );
}

class _FollowSpecialShopConnector
    extends ConnOp<DemoListAdapterState, List<ItemBean>> {
  @override
  List<ItemBean> get(DemoListAdapterState state) {
    print("<> get ---> ");
    if (state == null || state.list == null) return [];
    List<ItemBean> lists = List();
    if (state.list != null) {
      for (int i = 0; i < state.list.length; i++) {
        SpecialShopRelatedItemState shopItemState =
            SpecialShopRelatedItemState(index: i);
        lists.add(ItemBean("specialShopRelated", shopItemState));
      }
    }
    return lists;
  }

  @override
  void set(DemoListAdapterState state, List<ItemBean> subState) {
    super.set(state, subState);
    print("<> set ---> ");
    if (subState == null || subState.length == 0) return;
    List<SpecialShopRelatedItemState> relatedShopStates = List();
    for (int i = 0; i < subState.length; ++i) {
      ItemBean itemBean = subState[i];
      if (itemBean.type == "specialShopRelated") {
        relatedShopStates.add(itemBean.data);
      }
    }
  }
}
