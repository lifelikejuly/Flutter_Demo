import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action;
import 'package:flutter_template/flutter_temple.dart';
import 'action.dart';
import 'state.dart';
import 'package:flutter_demo/part/fishredux/demopage2/FishModel.dart';

Effect<fishdemepage2State> buildEffect() {
  return combineEffects(<Object, Effect<fishdemepage2State>>{
    Lifecycle.initState: _init,
    fishdemepage2Action.action: _onAction,
    fishdemepage2Action.actionAsync:_onActionAsync,
  });
}

void _onAction(Action action, Context<fishdemepage2State> ctx) {
}

void _init(Action action, Context<fishdemepage2State> ctx){
  print("fishdemepage2State _init");
  ctx.dispatch(fishdemepage2ActionCreator.onLoadData());
}

void _onActionAsync(Action action, Context<fishdemepage2State> ctx) async{
  print("fishdemepage2State _onActionAsync");
  HDialogUtil.showLoadingDialog(
    ctx.context,
  );
  List<FishModel> models = await Future.delayed(Duration(seconds: 2), (){
    List<FishModel> modles = List();
    modles.add(FishModel("ppppp2311"));
    modles.add(FishModel("ppppp2311"));
    modles.add(FishModel("ppppp2311"));
    modles.add(FishModel("ppppp2311"));
    modles.add(FishModel("ppppp2311"));
    return modles;
  });
  Navigator.of(ctx.context).pop();
  ctx.dispatch(fishdemepage2ActionCreator.onLoadDataAsync(models));
}