import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/page/lib/fishredux/demopage3/itemcell/state.dart';

class fishListState implements Cloneable<fishListState> {

  List<fishComponent1State> items = List();

  @override
  fishListState clone() {
    return fishListState();
  }
}

fishListState initState(Map<String, dynamic> args) {
  return fishListState();
}
