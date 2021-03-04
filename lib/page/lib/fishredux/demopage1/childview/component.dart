import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class Demo1ChildViewComponent extends Component<Demo1ChildViewState> {
  Demo1ChildViewComponent()
      : super(
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<Demo1ChildViewState>(
            adapter: null,
            slots: <String, Dependent<Demo1ChildViewState>>{},
          ),
        );
}
