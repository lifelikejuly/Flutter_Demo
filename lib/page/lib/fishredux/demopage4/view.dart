import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    masterPageState state, Dispatch dispatch, ViewService viewService) {
  Widget widget = viewService.buildComponent("main");
  return Scaffold(
    appBar: AppBar(),
    body: Container(
      child: widget,
    ),
  );
}
