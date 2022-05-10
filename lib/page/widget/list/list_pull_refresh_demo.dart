import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/page/common/common.dart';

class ListPullRefreshDemo extends StatefulWidget {
  @override
  _ListPullRefreshDemoState createState() => _ListPullRefreshDemoState();
}

class _ListPullRefreshDemoState extends State<ListPullRefreshDemo> {


  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _androidRefreshIndicatorWidget(),
        _iosRefreshIndicatorWidget(),
      ],
    );
  }

  _androidRefreshIndicatorWidget() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          print("<> RefreshIndicator onRefresh");
          await Future.delayed(Duration(seconds: 2));
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Common.getWidget(index);
          },
          itemCount: 100,
        ),
      ),
    );
  }

  _iosRefreshIndicatorWidget() {
    return Expanded(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          CupertinoSliverRefreshControl(
            onRefresh: () async {
                print("<> CupertinoSliverRefreshControl onRefresh");
            },
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (content, index) {
                return Common.getWidget(index);
              },
              childCount: 100,
            ),
          )
        ],
      ),
    );
  }
}
