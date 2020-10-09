import 'package:characters/characters.dart';
import 'package:flutter/material.dart';

/// 中英文混排 宽度足够的情况下英文被省略的问题
///
/// https://github.com/flutter/flutter/issues/63328
/// https://github.com/flutter/flutter/issues/18761
class TextDemo1 extends StatefulWidget {
  @override
  _TextDemo1State createState() => _TextDemo1State();
}

class _TextDemo1State extends State<TextDemo1> {
  @override
  void initState() {
    super.initState();
    String text = 'sdffgg';
    List list = text.runes.toList();
  }

  @override
  Widget build(BuildContext context) {


    var text;
    text = "哈哈sdsffdflllllllkkkl".replaceAll('', '\u2060');
    String message = "😁🀂🀁🀄︎🀖🀠＠🍊@㏒∮ΡΟㄇㄈㄞㄞㄝㄜ丄🍊〩⺻⺳橙美童kkkk🍊";
     message = "哈🀂🀁🀄︎🀖哈🀂🀁🀄︎🀖哈ssssddfgggllllllllkjjljljkl🀂🀁🀄︎🀖🀠＠@㏒∮ΡΟㄇㄈㄞㄞㄝ";
//    final exp = new RegExp('[\u4e00-\u9fa5]');
//     text = message.replaceAllMapped(exp,
//            (Match m) => "${m[0]}\u200B");

    text = Characters(message).toList().join("\u{200B}");
//    text = message.codeUnits.getRange(0, message.length).toList().join("\u{200B}");
//    text = message.replaceAll("", "\u{200B}");
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.orange,
            width: 200,
            child: Text(
              "哈哈sdsffdflllllllkkkl",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          Container(
            color: Colors.red,
            width: 200,
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

}
