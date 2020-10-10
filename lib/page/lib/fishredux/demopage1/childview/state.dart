import 'package:fish_redux/fish_redux.dart';

class Demo1ChildViewState implements Cloneable<Demo1ChildViewState> {
  int childNum = 0;

  Demo1ChildViewState({this.childNum}) {
    childNum = childNum ?? 0;
  }

  @override
  Demo1ChildViewState clone() {
    return Demo1ChildViewState(childNum: childNum);
  }
}

Demo1ChildViewState initState(Map<String, dynamic> args) {
  return Demo1ChildViewState();
}
