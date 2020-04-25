import 'package:fish_redux/fish_redux.dart';

class HeaderViewState implements Cloneable<HeaderViewState> {

  @override
  HeaderViewState clone() {
    return HeaderViewState();
  }
}

HeaderViewState initState(Map<String, dynamic> args) {
  return HeaderViewState();
}
