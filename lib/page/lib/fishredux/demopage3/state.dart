import 'package:fish_redux/fish_redux.dart';

class FishDemoListPageState implements Cloneable<FishDemoListPageState> {

  @override
  FishDemoListPageState clone() {
    return FishDemoListPageState();
  }
}

FishDemoListPageState initState(Map<String, dynamic> args) {
  return FishDemoListPageState();
}
