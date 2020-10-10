import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    fishComponent1State state, Dispatch dispatch, ViewService viewService) {
  return Container(
    child: Column(
      children: <Widget>[
        Text(state.name),
        Text(state.sex),
        Text("${state.num}"),
      ],
    ),
  );
}
