import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldDemo extends StatefulWidget {
  @override
  _TextFieldDemoState createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: (text) {
              print("TextField $text");
            },
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15, left: 28, right: 28),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 17),
            alignment: Alignment.center,
            height: 48,
            decoration: new BoxDecoration(
                color: Color(0xFFF2F2F2),
                borderRadius: new BorderRadius.circular(4)),
            child: TextField(
              textInputAction: TextInputAction.next,
              cursorColor: Colors.red,
              decoration: InputDecoration(
                hintText: "名字不超过八个字",
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0),
                counterStyle: TextStyle(
                  textBaseline: TextBaseline.alphabetic,
                ),
              ),
              style: TextStyle(
                textBaseline: TextBaseline.alphabetic,
              ),
              strutStyle: StrutStyle(
                forceStrutHeight: true,
              ),
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(8),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            height: 30,
            decoration: new BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: new BorderRadius.circular(4),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "res/img/ic_star.png",
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    cursorColor: Colors.grey,
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: "HHHHHH",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                        isDense: true,
                        hintStyle: TextStyle(fontSize: 15)),
                    style: TextStyle(fontSize: 15),
                    showCursor: true,
                    textInputAction: TextInputAction.search,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.centerLeft,
                  height: 30,
                  decoration: new BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: new BorderRadius.circular(4),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "res/img/ic_star.png",
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                              hintText: "HHHHHH",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(0),
                              isDense: true,
                              hintStyle: TextStyle(fontSize: 15)),
                          style: TextStyle(
                              fontSize: 15,
                              textBaseline: TextBaseline.alphabetic),
                          showCursor: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RaisedButton(
                child: Text("pppp"),
              )
            ],
          ),
        ],
      ),
    );
  }
}
