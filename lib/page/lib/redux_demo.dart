import 'package:flutter/material.dart';
import 'package:flutter_demo/thrid_libs/redux/redux.dart';

const String increment = 'INCREMENT';
const String decrement = 'DECREMENT';

class ReduxDemo extends StatefulWidget {
  const ReduxDemo({Key key}) : super(key: key);

  @override
  State<ReduxDemo> createState() => _ReduxDemoState();
}

class _ReduxDemoState extends State<ReduxDemo> {
  Store store;



  @override
  void initState() {
    super.initState();

    int counterReducer(int state, action) {
      switch (action) {
        case increment:
          return state + 1;
        case decrement:
          return state - 1;
        default:
          return state;
      }
    }

    loggingMiddleware2(Store<int> store, action, NextDispatcher next) {
      print('<<<<${new DateTime.now()}>>>>: $action');
      next(action);
    }

    store = new Store<int>(
      counterReducer,
      initialState: 0,
      middleware: [LoggingMiddleware(), loggingMiddleware2],
    );
    final subscription = store.onChange.listen(print);


    List<Function> functions = [];
    functions.add(() => print("<> functions"));
    functions.add(FunctionCall());
    functions.forEach((element) {element.call();});

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text("INCREMENT"),
            onTap: () {
              store.dispatch("INCREMENT");
            },
          ),
          ListTile(
            title: Text("DECREMENT"),
            onTap: () {
              store.dispatch("DECREMENT");
            },
          ),
        ],
      ),
    );
  }
}

class LoggingMiddleware extends MiddlewareClass<int> {

  call(Store<int> store, action, NextDispatcher next) {
    print('${new DateTime.now()}: $action');
    next(action);
  }

  // callIt(Object object, action, NextDispatcher next) {
  //   print("<> LoggingMiddleware callIt");
  // }
}

class FunctionCall {

  FunctionCall();

  call() => print("<> this is FunctionCall");
}


