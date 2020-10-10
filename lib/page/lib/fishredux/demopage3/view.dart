import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'list/state.dart';
import 'state.dart';

Widget buildView(
    fishListState state, Dispatch dispatch, ViewService viewService) {
  ListAdapter adapter = viewService.buildAdapter();
  Widget widget = viewService.buildComponent("header");
  return Scaffold(
    appBar: AppBar(),
    body: Container(
      child: Column(
        children: <Widget>[
          widget,
          Expanded(
            child: ListView.builder(
              itemBuilder: adapter.itemBuilder,
              itemCount: adapter.itemCount,
            ),
          ),
        ],
      ),
    ),
  );
}
