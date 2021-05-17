import 'package:flutter/material.dart';

final String IMAGE_SRC =
    "http://pic37.nipic.com/20140113/8800276_184927469000_2.png";

class HeroAnimationDemo extends StatefulWidget {
  @override
  _HeroAnimationDemoState createState() => _HeroAnimationDemoState();
}

class _HeroAnimationDemoState extends State<HeroAnimationDemo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Hero(
            tag: 'imgHero',
            child: Padding(
              padding: EdgeInsets.only(left: 100, top: 300),
              child: Image.network(
                IMAGE_SRC,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HeroPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class HeroPage extends StatefulWidget {
  @override
  _HeroPageState createState() => _HeroPageState();
}

class _HeroPageState extends State<HeroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.only(top: 100, left: 100),
        width: 300,
        child: GestureDetector(
          child: Hero(
            tag: 'imgHero',
            child: Image.network(
              IMAGE_SRC,
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
