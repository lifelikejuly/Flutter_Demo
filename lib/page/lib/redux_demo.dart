import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

enum ReduceActions { Increment, Reducement, change }

// The reducer, which takes the previous count and increments it in response
// to an Increment action.
AppState counterReducer(AppState state, dynamic action) {
  if (action == ReduceActions.Increment) {
    return state..count += 1;
  } else if (action == ReduceActions.Reducement) {
    return state..count -= 1;
  } else if (action == ReduceActions.change) {
    return state..change = !state.change;
  }

  return state;
}

class AppState {
  int count = 0;
  bool change = false;
}

class ReduxDemo extends StatefulWidget {
  @override
  _ReduxDemoState createState() => _ReduxDemoState();
}

class _ReduxDemoState extends State<ReduxDemo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StoreBuilder<AppState>(
          builder: (context, store) {
            return Text("${store.state.count}");
          },
        ),
        StoreConnector<AppState, DemoViewModel>(
          converter: DemoViewModel.fromStore,
          builder: (context, vm) {
            print("StoreConnector DemoViewModel");
            return Text("${vm.count}");
          },
          onInit: (store) {},
          onInitialBuild: (vm) {},
          onDidChange: (vm) {},
          onDispose: (store) {},
          distinct: true,
          rebuildOnChange: true,
        ),
        StoreConnector<AppState, DemoViewChangeModel>(
          converter: DemoViewChangeModel.fromStore,
          builder: (context, vm) {
            print("StoreConnector DemoViewChangeModel");
            return Text("${vm.change}");
          },
          onInit: (store) {},
          onInitialBuild: (vm) {},
          onDidChange: (vm) {},
          onDispose: (store) {},
          distinct: true,
//            ignoreChange: (state) {
//              return true;
//            },
          rebuildOnChange: true,
        ),
        Row(
          children: <Widget>[
            RaisedButton(
              child: Text("add"),
              onPressed: () {
                StoreProvider.of<AppState>(context)
                    .dispatch(ReduceActions.Increment);
              },
            ),
            RaisedButton(
              child: Text("reduce"),
              onPressed: () {
                StoreProvider.of<AppState>(context)
                    .dispatch(ReduceActions.Increment);
              },
            )
          ],
        ),
        RaisedButton(
          child: Text("change"),
          onPressed: () {
            StoreProvider.of<AppState>(context).dispatch(ReduceActions.change);
          },
        )
      ],
    );
  }
}

class DemoViewModel {
  int count;

  DemoViewModel({this.count});

  static DemoViewModel fromStore(Store<AppState> store) {
    return DemoViewModel(
      count: store.state.count * 2,
    );
  }
}

class DemoViewChangeModel {
  bool change;

  DemoViewChangeModel({this.change});

  static DemoViewChangeModel fromStore(Store<AppState> store) {
    return DemoViewChangeModel(
      change: store.state.change,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DemoViewChangeModel &&
          runtimeType == other.runtimeType &&
          change == other.change;

  @override
  int get hashCode => change.hashCode;
}
