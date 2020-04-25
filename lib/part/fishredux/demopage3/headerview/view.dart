import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(HeaderViewState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    height: 200,
    color: Colors.amberAccent,
    child: Center(
      child: Text("this is Header"),
    ),
  );
}
