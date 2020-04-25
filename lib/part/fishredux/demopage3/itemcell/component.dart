import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class fishComponent1Component extends Component<fishComponent1State> {
  fishComponent1Component()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<fishComponent1State>(
                adapter: null,
                slots: <String, Dependent<fishComponent1State>>{
                }),);

}
