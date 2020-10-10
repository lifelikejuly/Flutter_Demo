import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class FishDemoPage2Page extends Page<fishdemepage2State, Map<String, dynamic>> {
  FishDemoPage2Page()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<fishdemepage2State>(
                adapter: null,
                slots: <String, Dependent<fishdemepage2State>>{
                }),
            middleware: <Middleware<fishdemepage2State>>[
            ],);

}
