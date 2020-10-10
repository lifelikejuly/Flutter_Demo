import 'package:fish_redux/fish_redux.dart';

//状态管理类
class FishDemoPage1State implements Cloneable<FishDemoPage1State> {
  int total = 0;
  bool add = false;

  int childNum = 0;

  FishDemoPage1State({this.total = 0, this.add = false, this.childNum = 0});

  @override
  FishDemoPage1State clone() {
    return FishDemoPage1State()
      ..total = total
      ..add = add
      ..childNum = childNum;
  }
}

FishDemoPage1State initMainState(Map<String, dynamic> args) {
  return FishDemoPage1State();
}
