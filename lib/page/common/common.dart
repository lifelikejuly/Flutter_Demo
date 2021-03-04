import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Common {
  static List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.blue,
    Colors.amber,
    Colors.cyan,
    Colors.pink
  ];


  static List<Color> labelColors = [
    Colors.pinkAccent,
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.blue,
    Colors.amber,
    Colors.cyan,
    Colors.pink
  ];


  static Random random = new Random();

  static Color getRandomColor() {
    return colors.elementAt(random.nextInt(colors.length));
  }


  static Widget getWidget(int index,{Color iColor}){
    Color color = getRandomColor();
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: 300,
      width: 200,
      color: iColor ?? color,
      alignment: Alignment.center,
      child: Text(
        "$index",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
