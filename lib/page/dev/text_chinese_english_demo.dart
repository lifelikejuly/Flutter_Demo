import 'package:characters/characters.dart';
import 'package:flutter/material.dart';

class TextChineseEnglishDemo extends StatefulWidget {
  @override
  _TextChineseEnglishDemoState createState() => _TextChineseEnglishDemoState();
}

class _TextChineseEnglishDemoState extends State<TextChineseEnglishDemo> {
  String message1 = "哈哈sdsffdfll欧新授课；看了lllllkkkl";
  String message11 = "哈哈sdsffdflloojjjjjlllllkpppppppppppppkkl";
  String message2 = "😁🀂🀁🀄︎🀖🀠＠🍊@㏒∮ΡΟㄇㄈㄞㄞㄝㄜ丄🍊〩⺻⺳橙美童kkkk🍊";
  String message3 =
      "哈🀂🀁🀄︎🀖哈🀂🀁🀄︎🀖哈ssssddfgggllllllllkjjljljkl🀂🀁🀄︎🀖🀠＠@㏒∮ΡΟㄇㄈㄞㄞㄝ";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("文本中英文夹杂在一起就不会有问题"),
        _textWidget(message1),
        SizedBox(height: 20),
        Text("文本前面是中文后面跟着都是英文就有问题"),
        _textWidget(message11),
        SizedBox(height: 20),
        Text("而且也是不TextOverflow.ellipsis导致"),
        _textWidget(message11, overflow: TextOverflow.visible),
        SizedBox(height: 20),
        Text("通过Characters解决"),
        _textWidget(_toCharacters(message1)),
        SizedBox(height: 20),
        _textWidget(_toCharacters(message2)),
        SizedBox(height: 20),
        _textWidget(_toCharacters(message3)),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _textWidget(String text,
      {TextOverflow overflow = TextOverflow.ellipsis}) {
    return Container(
      color: Colors.orange,
      width: 200,
      child: Text(
        text,
        maxLines: 1,
        overflow: overflow,
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    );
  }

  String _toCharacters(String text) {
    // 若存在emoji则不适用会崩溃
//    final exp = new RegExp('[\u4e00-\u9fa5]');
//     text = message.replaceAllMapped(exp,
//            (Match m) => "${m[0]}\u200B");
//    text = message.codeUnits.getRange(0, message.length).toList().join("\u{200B}");
//    text = message.replaceAll("", "\u{200B}");

    return Characters(text).toList().join("\u{200B}");
  }
}
