import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/diy_sliver_customer.dart';

class SliverCustomerDemo extends StatefulWidget {
  @override
  _SliverCustomerDemoState createState() => _SliverCustomerDemoState();
}

class _SliverCustomerDemoState extends State<SliverCustomerDemo> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.center,
            child: Text("xixixix", style: TextStyle(color: Colors.white)),
            width: double.infinity,
            height: 200,
            color: Colors.pink,
          ),
        ),
        DIYSliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          sliver: SliverToBoxAdapter(
            child: Container(
              width: 10,
              height: 20,
              child: Text("KKK"),
            ),
          ),
        ),
        DIYSliverToBoxAdapter(
          child: Container(
            width: 10,
            height: 20,
            child: Text("KKK"),
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
