import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/page/lib/fishredux/demopage4/child/component.dart';
import 'package:flutter_demo/page/lib/fishredux/demopage4/child/state.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class mainComponent extends Component<mainState> {
  mainComponent()
      : super(
    effect: buildEffect(),
    reducer: buildReducer(),
    view: buildView,
    dependencies: Dependencies<mainState>(
        adapter: null,
        slots: <String, Dependent<mainState>>{
          "child1":
//            ConnOp<mainState, ChildState>(
//                  get: (state) {
//                    println("ReduxData main get state ${state.child1Num}");
//                    return ChildState();
//                  },
//                  set: (s, p) {
//                    println("ReduxData main set s ${s.child1Num} p ${p.num}");
//                    s.child1Num = p.num;
//                  },
//                )
          ChildConOp() + ChildComponent(),
//                "child2": ConnOp<mainState, ChildState>(
//                      get: (_) {
//                        return ChildState();
//                      },
//                      set: (s, p) {},
//                    ) +
//                    ChildComponent(),
//                "child3": ConnOp<mainState, ChildState>(
//                      get: (_) {
//                        return ChildState();
//                      },
//                      set: (s, p) {},
//                    ) +
//                    ChildComponent(),
        }),
  );
}

class ChildConOp extends ConnOp<mainState, ChildState> with ReselectMixin {
  ChildState childState;

//  @override
//  ChildState get(mainState state) {
//    if (childState == null) {
//      childState = ChildState(child1Num: state.child1Num);
//    }
//    println("ReduxData main get state ${state.child1Num}");
//    println("ReduxData main get childState ${childState.child1Num}");
//    return ChildState(child1Num: state.child1Num);
////    return childState;
//  }


  @override
  void set(mainState state, ChildState subState) {
    println("ReduxData main set state ${state.child1Num} subState ${subState.child1Num}");
    childState.child1Num = subState.child1Num;
    state.child1Num = subState.child1Num;
  }

  @override
  ChildState computed(mainState state) {
    if(childState == null){
      childState = ChildState(child1Num: state.child1Num);
    }
    println("ReduxData main computed state ${state.child1Num}");
    return childState;
  }
}
