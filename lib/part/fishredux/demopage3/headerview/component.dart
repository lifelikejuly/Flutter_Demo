import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/part/fishredux/demopage3/list/state.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class HeaderViewComponent extends Component<HeaderViewState> {
  HeaderViewComponent()
      : super(
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<HeaderViewState>(
              adapter: null, slots: <String, Dependent<HeaderViewState>>{}),
        );
}

class HeaderViewConnector extends ConnOp<fishListState, HeaderViewState> {
  @override
  HeaderViewState get(fishListState state) {
    return HeaderViewState();
  }

  @override
  void set(fishListState state, HeaderViewState subState) {
    super.set(state, subState);
  }
}
