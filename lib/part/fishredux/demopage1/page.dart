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
          "child": ConnOp<FishDemoPage1State, Demo1ChildViewState>(
              get: (state) {
                return Demo1ChildViewState();
              },
              set: (p, c) {

              }
          ) +
              Demo1ChildViewComponent(),
        }),
    middleware: <Middleware<FishDemoPage1State>>[],
  );
}
