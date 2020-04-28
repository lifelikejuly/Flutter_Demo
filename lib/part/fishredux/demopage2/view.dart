import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    fishdemepage2State state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(),
    body: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            RaisedButton(
              child: Text("load"),
              onPressed: () {
                dispatch(fishdemepage2ActionCreator.onLoadData());
              },
            ),
            RaisedButton(
              child: Text("loadAsync"),
              onPressed: () {
                dispatch(fishdemepage2ActionCreator.onActionAsync());
              },
            )
          ],
        ),
        Expanded(
          child: Container(
            child: GridView.count(
              crossAxisCount: 2,
              //列数
              crossAxisSpacing: 20.0,
              // 左右间隔
              mainAxisSpacing: 20.0,
              // 上下间隔
              childAspectRatio: 1 / 1,
              //宽高比
              padding: EdgeInsets.all(20),
              children: new List.generate(state.models.length, (index) {
                //使用state里面的models生成列表
                return Center(
                    child: Card(
                  color: Colors.lightBlueAccent,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(100),
                    onTap: () {
                      //todo 点击事件
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      child: Center(
                        child: Text(state.models[index].name), //展示name字段
                      ),
                    ),
                  ),
                ));
              }),
            ),
          ),
        )
      ],
    ),
  );
}
