import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';
//页面内容
class FishDemoPage1Page extends Page<FishDemoPage1State, Map<String, dynamic>> {
  FishDemoPage1Page()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<FishDemoPage1State>(
                adapter: null,
                slots: <String, Dependent<FishDemoPage1State>>{
                }),
            middleware: <Middleware<FishDemoPage1State>>[
            ],);

}
