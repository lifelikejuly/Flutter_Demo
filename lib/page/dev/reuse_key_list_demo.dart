import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReuseKeyListDemo extends StatefulWidget {
  @override
  _ReuseKeyListDemoState createState() => _ReuseKeyListDemoState();
}

class _ReuseKeyListDemoState extends State<ReuseKeyListDemo> {
  var items = [
    false,
    true,
    false,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    false,
    true,
    true,
    false,
    true,
    true,
    false,
    true,
    true,
    true,
    false,
    true
  ];

  var itemValue = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          child: ItemCell(
            items[index],
            "cell ${itemValue[index]}",
            key: Key("${items[index]}"),
            // 增加一个Key值可以避免删除复用问题。didUpdateWidget会使用上一个删除Widget参数。
            // 使用Key保障唯一性。
          ),
          onLongPress: () {
            items.removeAt(0);
            itemValue.removeAt(0);
            setState(() {});
          },
        );
      },
      itemCount: items.length,
    );
  }
}

class ItemCell extends StatefulWidget {
  final bool value;
  final String data;

  ItemCell(this.value, this.data, {Key key}) : super(key: key);

  @override
  _ItemCellState createState() => _ItemCellState();
}

class _ItemCellState extends State<ItemCell> with TickerProviderStateMixin {
  bool get value => widget.value;

  String get data => widget.data;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.amber,
        height: 100,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(data + " $value"),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: 30 + _controller.value * 10,
                      height: 30 + _controller.value * 10,
                      color: Colors.red,
                    );
                  },
                )
              ],
            ),
            Container(
              height: 1,
              color: Colors.black,
            )
          ],
        ));
  }

  @override
  void didUpdateWidget(ItemCell oldWidget) {
    if (oldWidget.value != value) {
      if (_controller != null) {
        if (value) {
          _controller?.duration = Duration(seconds: 2);
          _controller?.forward();
        } else {
          _controller?.value = 0;
          _controller?.stop(canceled: true);
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.stop(canceled: true);
    _controller?.dispose();
  }
}
