import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(SpecialShopRelatedItemState state, Dispatch dispatch,
    ViewService viewService) {
  return SpecialShopRelatedItemView(state, dispatch, viewService);
}

class SpecialShopRelatedItemView extends StatelessWidget {
  final SpecialShopRelatedItemState state;
  final Dispatch dispatch;
  final ViewService viewService;

  SpecialShopRelatedItemView(this.state, this.dispatch, this.viewService);

  @override
  Widget build(BuildContext context) {
    print("<> build -----> ");
    Widget child;
    child = Container(
        height: 100,
        child: Column(
          children: <Widget>[
            Text("${state.index} --- ${state.listIndex}"),
            FlatButton(
              child: Text("+"),
              onPressed: () {
                SpecialShopRelatedItemState newState = state.clone();
                dispatch(SpecialShopRelatedItemActionCreator.onChangeShops(
                    newState));
              },
            )
          ],
        ));
    return child;
  }
}
