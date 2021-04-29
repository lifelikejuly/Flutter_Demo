import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DragGridViewDemo extends StatefulWidget {
  @override
  _DragGridViewDemoState createState() => _DragGridViewDemoState();
}

class _DragGridViewDemoState extends State<DragGridViewDemo> {


  final _titles = ['OC', 'Swift', 'Java', 'C','C++','C#','Dart','Python','Go'];
  String _movingValue;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 300,
      height: 300,
      color: Colors.grey,
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            childAspectRatio: 1),
        children: buildItems(),
        physics: NeverScrollableScrollPhysics(), //禁止滚动
      ),
    ));
  }




  // 生成GridView的items
  List<Widget> buildItems() {
    List<Widget> items = List<Widget>();
    _titles.forEach((value) {
      items.add(draggableItem(value));
    });
    return items;
  }

  // 生成可拖动的item
  Widget draggableItem(value) {
    return Draggable(
      data: value,
      child: DragTarget(
        builder: (context, candidateData, rejectedData) {
          return baseItem(value,Colors.blue);
        },
        onWillAccept: (moveData) {
          print('=== onWillAccept: $moveData ==> $value');

          var accept = moveData != null;
          if (accept) {
            exchangeItem(moveData, value, false);
          }
          return accept;
        },
        onAccept: (moveData) {
          print('=== onAccept: $moveData ==> $value');
          exchangeItem(moveData, value, true);
        },
        onLeave: (moveData) {
          print('=== onLeave: $moveData ==> $value');
        },
      ),
      feedback: baseItem(value,Colors.green.withOpacity(0.8)),
      childWhenDragging: null,
      onDragStarted: () {
        print('=== onDragStarted');
        setState(() {
          _movingValue = value;//记录开始拖拽的数据
        });
      },
      onDraggableCanceled: (Velocity velocity, Offset offset) {
        print('=== onDraggableCanceled');
        setState(() {
          _movingValue = null;//清空标记进行重绘
        });
      },
      onDragCompleted: () {
        print('=== onDragCompleted');
      },
    );
  }
  // 基础展示的item 此处设置width,height对GridView 无效，主要是偷懒给feedback用
  Widget baseItem(value, bgColor) {
    if (value == _movingValue) {
      return Container();
    }
    return Container(
      width: 110,
      height: 110,
      color: bgColor,
      child: Center(
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.yellowAccent),
        ),
      ),
    );
  }

  // 重新排序
  void exchangeItem(moveData, toData, onAccept) {
    print("<>  exchangeItem");
    setState(() {
      var toIndex = _titles.indexOf(toData);

      _titles.remove(moveData);
      _titles.insert(toIndex, moveData);

      if (onAccept) {
        _movingValue = null;
      }
    });
  }
}
