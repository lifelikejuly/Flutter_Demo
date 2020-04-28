import 'package:fish_redux/fish_redux.dart';

class Demo1ChildViewState implements Cloneable<Demo1ChildViewState> {

  @override
  Demo1ChildViewState clone() {
    return Demo1ChildViewState();
  }

}

Demo1ChildViewState initState(Map<String, dynamic> args) {
  return Demo1ChildViewState();
}


