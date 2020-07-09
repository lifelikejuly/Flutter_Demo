import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/part/fishredux/demopage1/childview/component.dart';
import 'package:flutter_demo/part/fishredux/demopage1/childview/state.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

//页面内容
class FishDemoPage1Page extends Page<FishDemoPage1State, Map<String, dynamic>> {
  FishDemoPage1Page()
      : super(
          initState: initMainState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<FishDemoPage1State>(
              adapter: null,
              slots: <String, Dependent<FishDemoPage1State>>{
                "child": ChildConnOp() + Demo1ChildViewComponent(),
              }),
          middleware: <Middleware<FishDemoPage1State>>[],
        );
}

class ChildConnOp extends ConnOp<FishDemoPage1State, Demo1ChildViewState> {
  Demo1ChildViewState _state;

  @override
  Demo1ChildViewState get(FishDemoPage1State state) {
    print("FishDemoPage1Page ConnOp get");
    if (_state == null) {
      _state = Demo1ChildViewState(childNum: state.childNum);
    }
    return Demo1ChildViewState(childNum: state.childNum);
  }

  @override
  void set(FishDemoPage1State state, Demo1ChildViewState subState) {
//    super.set(state, subState);
    print("FishDemoPage1Page ConnOp set");
    state.childNum = subState.childNum;
  }
}
