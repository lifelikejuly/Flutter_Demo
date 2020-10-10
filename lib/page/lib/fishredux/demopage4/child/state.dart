import 'package:fish_redux/fish_redux.dart';

class ChildState implements Cloneable<ChildState> {
  int child1Num = 0;

  ChildState({this.child1Num = 0}) {
    this.child1Num = child1Num ?? 0;
  }

  @override
  ChildState clone() {
    return ChildState(child1Num: child1Num);
  }
}

ChildState initState(Map<String, dynamic> args) {
  return ChildState();
}
