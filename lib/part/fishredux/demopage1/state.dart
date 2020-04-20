import 'package:fish_redux/fish_redux.dart';

class FishDemoPage1State implements Cloneable<FishDemoPage1State> {
  int total = 0;
  bool add = false;

  FishDemoPage1State({this.total = 0, this.add = false});

  @override
  FishDemoPage1State clone() {
    return FishDemoPage1State()
      ..total = total
      ..add = add;
  }
}

FishDemoPage1State initState(Map<String, dynamic> args) {
  return FishDemoPage1State();
}
