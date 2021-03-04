import 'package:flutter/widgets.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:uuid/uuid.dart';

class SpecialShopRelatedItemState
    implements Cloneable<SpecialShopRelatedItemState>  {
  int index;

  int listIndex;



  SpecialShopRelatedItemState({this.index, this.listIndex = 1, String uniqueId});

  @override
  SpecialShopRelatedItemState clone() {
    return SpecialShopRelatedItemState(
      index: index,
      listIndex: listIndex,
    );
  }

}

abstract class UniqueIdState<T extends UniqueIdState<T>>
    implements Cloneable<T> {
  final String uniqueId;

  UniqueIdState(String uniqueId) : this.uniqueId = uniqueId ?? Uuid().v4();
}
