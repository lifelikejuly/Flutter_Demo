import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/sprite/sprite_image.dart';

class CustomeSpriteDemo extends StatefulWidget {
  @override
  State<CustomeSpriteDemo> createState() => _CustomeSpriteDemoState();
}

class _CustomeSpriteDemoState extends State<CustomeSpriteDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Transform.scale(
        scale: 5.0,
        child: SpriteWidget(
          duration: Duration(milliseconds: 200), //动画的间隔
          image: Image.asset("res/img/user_role.png"), //精灵图
          spriteSize: Size(48.0, 48.0), //单画面尺寸
        ),
      ),
    );
  }
}
