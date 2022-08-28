import 'package:flutter/widgets.dart';

class ListDemo extends StatefulWidget {

  @override
  State<ListDemo> createState() => _ListDemoState();
}

class _ListDemoState extends State<ListDemo> {


  @override
  void initState() {
    super.initState();
    List<int>  lists = List(3);
    lists.addAll([2,3,4]);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }
}
