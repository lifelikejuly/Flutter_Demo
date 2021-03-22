import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/page/lib/fishredux/list/view/state.dart';

class DemoListAdapterState
    implements Cloneable<DemoListAdapterState>, MutableSource {
  // List<String> list;

  List<SpecialShopRelatedItemState> list;

  DemoListAdapterState({this.list}) {
    this.list ??= [];
  }

  @override
  DemoListAdapterState clone() {
    return DemoListAdapterState(list: list);
  }

  @override
  Object getItemData(int index) {
    return list[index];
  }

  @override
  String getItemType(int index) {
    return "specialShopRelated";
  }

  @override
  int get itemCount => list?.length ?? 0;

  @override
  void setItemData(int index, Object data) {
    list[index] = data;
  }

  @override
  MutableSource updateItemData(int index, Object data, bool isStateCopied) {
    final MutableSource result = isStateCopied ? this : clone();
    return result..setItemData(index, data);
  }
}

DemoListAdapterState initState(Map<String, dynamic> args) {
  var list = [
    "1111",
    "1111",
    "1111",
    "1111",
    "1111",
    "1111",
    "1111",
    "1111",
    "1111",
    "1111",
    "1111",
    "1111",
    "1111",
  ];
  List<SpecialShopRelatedItemState> lists = List();
  for (int i = 0; i < list.length; i++) {
    lists.add(SpecialShopRelatedItemState(index: i));
  }
  return DemoListAdapterState(list: lists);
}
