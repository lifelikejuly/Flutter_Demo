import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ChildComponent extends Component<ChildState> {
  ChildComponent()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ChildState>(
                adapter: null,
                slots: <String, Dependent<ChildState>>{
                }),);

}
