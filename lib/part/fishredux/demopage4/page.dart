import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/part/fishredux/demopage4/main/state.dart'
    hide initState;

import 'effect.dart';
import 'main/component.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class masterPagePage extends Page<masterPageState, Map<String, dynamic>> {
  masterPagePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<masterPageState>(
              adapter: null,
              slots: <String, Dependent<masterPageState>>{
                "main": ConnOp<masterPageState, mainState>(
                      get: (state) {
                        println("ReduxData master get");
                        return mainState(child1Num: state.num);
                      },
                      set: (s, p) {
                        s.num = p.child1Num;
                        println("ReduxData master set");
                      },
                    ) +
                    mainComponent()
              }),
          middleware: <Middleware<masterPageState>>[],
        );
}
