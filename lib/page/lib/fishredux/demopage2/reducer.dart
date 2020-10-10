import 'package:fish_redux/fish_redux.dart';

import 'FishModel.dart';
import 'action.dart';
import 'state.dart';

Reducer<fishdemepage2State> buildReducer() {
  return asReducer(
    <Object, Reducer<fishdemepage2State>>{
      fishdemepage2Action.action: _onAction,
      fishdemepage2Action.loadData: _onLoad,
      fishdemepage2Action.loadDataAsync: _onLoadAsync,
    },
  );
}

fishdemepage2State _onAction(fishdemepage2State state, Action action) {
  final fishdemepage2State newState = state.clone();
  return newState;
}

fishdemepage2State _onLoad(fishdemepage2State state, Action action) {
  println("fishdemepage2State _onLoad");
  List<FishModel> modles = List();
  modles.add(FishModel("ppppp2311"));
  modles.add(FishModel("ppppp2311"));
  modles.add(FishModel("ppppp2311"));
  modles.add(FishModel("ppppp2311"));
  modles.add(FishModel("ppppp2311"));
  final fishdemepage2State newState = state.clone()..models.addAll(modles);
  return newState;
}


fishdemepage2State _onLoadAsync(fishdemepage2State state, Action action) {

  final fishdemepage2State newState = state.clone()..models.addAll(action.payload);
  return newState;
}