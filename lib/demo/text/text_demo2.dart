import 'package:characters/characters.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// 中英文混排 宽度足够的情况下英文被省略的问题
///
/// https://github.com/flutter/flutter/issues/63328
/// https://github.com/flutter/flutter/issues/18761
class TextDemo2 extends StatefulWidget {
  @override
  _TextDemo1State createState() => _TextDemo1State();
}

class _TextDemo1State extends State<TextDemo2> {


  TapGestureRecognizer _tapRecognizer;


  @override
  void initState() {
    super.initState();
    _tapRecognizer = TapGestureRecognizer()
      ..onTap = () => print('tapped');
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(),
      body:Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
//            TextSpan(
//              text: 'find the',
//              style: TextStyle(
//                color: Colors.green,
//                decoration: TextDecoration.underline,
//                decorationStyle: TextDecorationStyle.wavy,
//              ),
//              recognizer: _tapRecognizer,
//            ),
//            TextSpan(
//              text: ' secret?',
//            ),
//            WidgetSpan(
//                child: Icon(Icons.search)
//            ),
            TextSpan(text: "lkkk"),
            WidgetSpan(
                child: SizedBox(
                  width: 20,
                )),
            TextSpan(
                text: '点击查看奖品详情',
                recognizer: TapGestureRecognizer()
                  ..onTap = () => {
                    print('tapped')
                  },
                style: TextStyle(color: Colors.orange)),
            WidgetSpan(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 13,
                ))
          ],
        ),

      )
    );
  }

}
