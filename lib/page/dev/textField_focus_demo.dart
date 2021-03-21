import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class TextFieldFocusDemo extends StatefulWidget {
  @override
  _TextFieldFocusDemoState createState() => _TextFieldFocusDemoState();
}

class _TextFieldFocusDemoState extends State<TextFieldFocusDemo> {
  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  TextEditingController textEditingController1 = new TextEditingController();
  TextEditingController textEditingController2 = new TextEditingController();
  @override
  void initState() {
    super.initState();
    textEditingController1.addListener(() {
        String text = textEditingController1.text;
        TextSelection textSelection = textEditingController1.selection;
        int start = textSelection.start;
        int end = textSelection.end;
        print("<> textSelection text $text start $start end $end");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          TextField(
              autofocus: true,
              focusNode: focusNode1,
              controller: textEditingController1,
              decoration: InputDecoration(hintText: "focusNode1")),
          TextField(
              autofocus: true,
              focusNode: focusNode2,
              controller: textEditingController2,
              decoration: InputDecoration(hintText: "focusNode2")),
          MaterialButton(
            child: Text("失去焦点"),
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
          ),
          MaterialButton(
            child: Text("获取焦点1"),
            onPressed: () {
              FocusScope.of(context).requestFocus(focusNode1);
            },
          ),
          MaterialButton(
            child: Text("光标向前"),
            onPressed: () {
              int start = textEditingController1.selection.start;
              int end = textEditingController1.selection.end;
              int length = textEditingController1.text.length;
              start = start < length ? start + 1 : length;
              end = end < length ? end + 1 : length;
              textEditingController1.selection = TextSelection(baseOffset: start,extentOffset: end);
            },
          ),
          MaterialButton(
            child: Text("光标向后"),
            onPressed: () {
              int start = textEditingController1.selection.start;
              int end = textEditingController1.selection.end;
              start = start > 0 ? start - 1 : 0;
              end = end > 0 ? end - 1 : 0;
              textEditingController1.selection = TextSelection(baseOffset: start,extentOffset: end);
            },
          ),
          MaterialButton(
            child: Text("获取焦点2"),
            onPressed: () {
              FocusScope.of(context).requestFocus(focusNode2);
            },
          ),
          MaterialButton(
            child: Text("唤起软键盘"),
            onPressed: () {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                SystemChannels.textInput.invokeMethod('TextInput.show');
              });
            },
          ),
          MaterialButton(
            child: Text("隐藏软键盘"),
            onPressed: () {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              });
            },
          ),
          MaterialButton(
            child: Text("跳转到下个页面返回后获取焦点"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => FocusNodeDemoPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FocusNodeDemoPage extends StatefulWidget {
  @override
  _FocusNodeDemoPageState createState() => _FocusNodeDemoPageState();
}

class _FocusNodeDemoPageState extends State<FocusNodeDemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
            ),
            MaterialButton(
              child: Text("无内容"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
