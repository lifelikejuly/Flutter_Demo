import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/part/fishredux/demopage3/headerview/component.dart';
import 'package:flutter_demo/part/fishredux/demopage3/list/adapter.dart';
import 'package:flutter_demo/part/fishredux/demopage3/list/state.dart';

import 'effect.dart';
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
