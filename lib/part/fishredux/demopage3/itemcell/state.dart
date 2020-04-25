import 'package:fish_redux/fish_redux.dart';

class fishComponent1State implements Cloneable<fishComponent1State> {
  String name;
  String sex;
  int num;


  fishComponent1State({this.name, this.sex, this.num});

  @override
  fishComponent1State clone() {
    return fishComponent1State()
      ..name = this.name
      ..sex = this.sex
      ..num = this.num;
  }
}

fishComponent1State initState(Map<String, dynamic> args) {
  return fishComponent1State();
}
