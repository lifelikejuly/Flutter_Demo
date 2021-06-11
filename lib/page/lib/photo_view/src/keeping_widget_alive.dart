import 'package:flutter/widgets.dart';


class KeepingWidgetAlive extends StatefulWidget {
  final Widget child;

  // ignore: sort_constructors_first
  const KeepingWidgetAlive({Key key, this.child}) : super(key: key);

  @override
  _KeepingWidgetAliveState createState() => _KeepingWidgetAliveState();
}

class _KeepingWidgetAliveState extends State<KeepingWidgetAlive> with AutomaticKeepAliveClientMixin{

  @override
    void initState() {
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}