import 'dart:convert';

import 'package:flutter/material.dart';

class MapDemo extends StatefulWidget {
  @override
  _MapDemoState createState() => _MapDemoState();
}

class _MapDemoState extends State<MapDemo> {


  Map<String, dynamic> get baseMap1 {
    var params = {
      "kk1": "1",
      "kk2": "ppp",
    };
    return params;
  }

  Map<String, dynamic> get baseMap2 {
    Map<String, dynamic> params = {
      "kk1": "1",
      "kk2": "ppp",
    };
    return params;
  }

  Map<String, dynamic> get baseMap3 {
    dynamic params = {
      "kk1": "1",
      "kk2": "ppp",
    };
    return params;
  }


  Map<String, dynamic> get baseMap4 {
    var params = {
      "kk1": "1",
      "kk2": 222,
    };
    return params;
  }

  Map<String, String> get baseMap5 {
    var params = {
      "kk1": "1",
      "kk2": "2",
    };
    return params;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("var map = {纯字符串}"),
            onPressed: () {
              var result = baseMap1..addAll({
                "kk3": "1",
                "kk4": 4444,
              });
              _showResult(result);
            },
          ),
          RaisedButton(
            child: Text("Map<String, dynamic> map = {纯字符串}"),
            onPressed: () {
              var result = baseMap2..addAll({
                "kk3": "1",
                "kk4": 4444,
              });
              _showResult(result);
            },
          ),
          RaisedButton(
            child: Text("dynamic map = {字符串}"),
            onPressed: () {
              var result = baseMap3..addAll({
                "kk3": "1",
                "kk4": 4444,
              });
              _showResult(result);
            },
          ),
          RaisedButton(
            child: Text("var map = {字符串、数字}"),
            onPressed: () {
              var result = baseMap4..addAll({
                "kk3": "1",
                "kk4": 4444,
              });
              _showResult(result);
            },
          ),
//          RaisedButton(
//            child: Text("var map = {字符串、数字}"),
//            onPressed: () {
//              var result = baseMap5..addAll({
//                "kk3": "1",
//                "kk4": 4444,
//              });
//              _showResult(result);
//            },
//          ),
          RaisedButton(
            child: Text("Map<String, dynamic> to Map<String, String> Func"),
            onPressed: () {
              _mapString(baseMap4);
            },
          ),
          RaisedButton(
            child: Text("Map<String, String> to Map<String, dynamic> Func"),
            onPressed: () {
              _mapDynamic(baseMap5);
            },
          ),
        ],
      ),
    );
  }

  _showResult(var result){
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("${jsonEncode(result)}")));
  }

  _mapString(Map<String, String> into){
    _showResult(into);
  }
  _mapDynamic(Map<String, dynamic> into){
    _showResult(into);
  }
}
/// 这个Demo主要验证 map添加数据时发生的问题，原先怀疑是Map<,>类型转换问题
/// 最终发现是在某处初始化赋值时使用了var，由于初始化Map中都是String-String因此导致初始化Map是Map<String,String>
/// 在之后add数据无法适用存在其他类型变量
/// var 	 ： 【编译期】确定【变量类型】
/// dynamic	 ： 【运行期】确定【变量类型】
///
/// 所以在不确定Map具体类型时采用<String,dynamic>避免报错
/// 在精确添加时采用<String,dynamic>在开发编译中规避错误