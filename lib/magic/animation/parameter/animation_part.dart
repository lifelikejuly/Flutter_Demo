import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';

class AnimationPart {
  int moment;
  Vector3 xyz;
  Curve curve;

  AnimationPart({
    @required this.moment,
    this.curve = Curves.linear,
    double x = 1.0,
    double y = 1.0,
    double z = 1.0,
  }) : xyz = Vector3(x, y, z);
}
