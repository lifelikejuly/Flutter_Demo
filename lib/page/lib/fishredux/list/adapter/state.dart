import 'package:fish_redux/fish_redux.dart';

class FollowSpecialShopState implements Cloneable<FollowSpecialShopState> {
  List<String> list;

  int index;

  FollowSpecialShopState({this.list, this.index = 1});

  @override
  FollowSpecialShopState clone() {
    return FollowSpecialShopState(
      list: list,
      index: index,
    );
  }
}
