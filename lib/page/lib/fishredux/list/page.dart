import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_demo/page/lib/fishredux/list/adapter/state.dart';

import 'adapter/adapter.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class DemoListAdapterPage
    extends Page<DemoListAdapterState, Map<String, dynamic>> {
  DemoListAdapterPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<DemoListAdapterState>(
              // adapter: ConnOp<DemoListAdapterState, FollowSpecialShopState>(
              //       set: (a, b) {
              //         b.list = a.list;
              //       },
              //       get: (a) {
              //         return FollowSpecialShopState(
              //           list: a.list,
              //         );
              //       },
              //     ) +
              //     FollowSpecialShopAdapter(),
              adapter: NoneConn<DemoListAdapterState>() +
                  FollowSpecialShopAdapter(),
              slots: <String, Dependent<DemoListAdapterState>>{}),
          middleware: <Middleware<DemoListAdapterState>>[],
        );
}
