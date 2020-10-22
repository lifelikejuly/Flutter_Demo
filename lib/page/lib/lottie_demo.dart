import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieDemo extends StatefulWidget {
  @override
  _LottieDemoState createState() => _LottieDemoState();
}

class _LottieDemoState extends State<LottieDemo> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Lottie.asset(
          'res/lottie/LottieLogo1.json',
        ),
        Lottie.network(
          'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json',
        ),
        Lottie.asset(
          'res/lottie/angel.zip',
        ),
      ],
    );
  }
}
