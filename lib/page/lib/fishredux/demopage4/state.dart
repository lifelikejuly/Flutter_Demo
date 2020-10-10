import 'package:fish_redux/fish_redux.dart';

class masterPageState implements Cloneable<masterPageState> {
  int num = 0;

  masterPageState({this.num}) {
    this.num = num ?? 0;
  }

  @override
  masterPageState clone() {
    return masterPageState(num: num);
  }
}

masterPageState initState(Map<String, dynamic> args) {
  return masterPageState();
}
