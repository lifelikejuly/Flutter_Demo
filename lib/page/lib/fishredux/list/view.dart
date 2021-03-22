import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    DemoListAdapterState state, Dispatch dispatch, ViewService viewService) {
  print("<> ---- > page buildView");
  ListAdapter listAdapter = viewService?.buildAdapter();
  return Scaffold(
    appBar: AppBar(),
    body: Container(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return listAdapter.itemBuilder(context,index);
        },
        itemCount: listAdapter?.itemCount ?? 0,
      ),
    ),
  );
}
