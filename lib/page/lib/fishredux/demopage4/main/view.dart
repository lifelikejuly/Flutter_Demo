import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(mainState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    child: Column(
      children: <Widget>[
        viewService.buildComponent("child1"),
//        viewService.buildComponent("child2"),
//        viewService.buildComponent("child3"),
      ],
    ),
  );
}
