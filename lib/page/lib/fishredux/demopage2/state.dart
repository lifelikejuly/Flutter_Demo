import 'package:fish_redux/fish_redux.dart';

import 'FishModel.dart';

class fishdemepage2State implements Cloneable<fishdemepage2State> {
  List<FishModel> models = List();

  @override
  fishdemepage2State clone() {
    return fishdemepage2State()..models = models;
  }
}

fishdemepage2State initState(Map<String, dynamic> args) {
  return fishdemepage2State();
}
