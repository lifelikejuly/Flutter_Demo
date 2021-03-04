import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SpecialShopRelatedItemComponent
    extends Component<SpecialShopRelatedItemState> {
  SpecialShopRelatedItemComponent()
      : super(
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
        );
}
