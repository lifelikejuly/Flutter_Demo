import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'headerview/component.dart';
import 'list/adapter.dart';
import 'list/state.dart';
import 'reducer.dart';
import 'view.dart';

class FishDemoListPagePage extends Page<fishListState, Map<String, dynamic>> {
  FishDemoListPagePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<fishListState>(
              adapter: NoneConn<fishListState>() + fishListAdapter(),
              slots: <String, Dependent<fishListState>>{
                "header": HeaderViewConnector() + HeaderViewComponent()
              }),
          middleware: <Middleware<fishListState>>[],
        );
}
