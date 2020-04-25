import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/part/fishredux/demopage3/itemcell/state.dart';
import 'package:flutter_demo/part/fishredux/demopage3/itemcell/component.dart';
import 'state.dart';

class fishListAdapter extends DynamicFlowAdapter<fishListState> {
  fishListAdapter()
      : super(
          pool: <String, Component<Object>>{
            "item": fishComponent1Component(),
          },
          connector: _fishListConnector(),
        );
}

class _fishListConnector extends ConnOp<fishListState, List<ItemBean>> {
  @override
  List<ItemBean> get(fishListState state) {
    //判断ListState里面的items数据是否为空
    if (state.items?.isNotEmpty == true) {
      //若不为空，把item数据转化成ItemBean的列表
      return state.items
          .map<ItemBean>((fishComponent1State data) => ItemBean('item', data))
          .toList(growable: true);
    } else {
      //若为空，返回空列表
      return <ItemBean>[];
    }
  }

  @override
  void set(fishListState state, List<ItemBean> items) {
    //把ItemBean的变化，修改到item的state的过程
    if (items?.isNotEmpty == true) {
      state.items = List<fishComponent1State>.from(items
          .map<fishComponent1State>((ItemBean bean) => bean.data)
          .toList());
    } else {
      state.items = <fishComponent1State>[];
    }
  }

  @override
  subReducer(reducer) {
    // TODO: implement subReducer
    return super.subReducer(reducer);
  }
}
