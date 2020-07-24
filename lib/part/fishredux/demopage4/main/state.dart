import 'package:fish_redux/fish_redux.dart';

class mainState implements Cloneable<mainState> {
  int child1Num = 0;

  mainState({this.child1Num = 0}) {
    this.child1Num = child1Num ?? 0;
  }

  @override
  mainState clone() {
    return mainState(child1Num: child1Num);
  }
}

mainState initState(Map<String, dynamic> args) {
  return mainState();
}
