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
  TextEditingController textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TextField(
              autofocus: true,
              focusNode: focusNode1,
              controller: textEditingController,
              decoration: InputDecoration(hintText: "focusNode1")),
          TextField(
              autofocus: true,
              focusNode: focusNode2,
              controller: textEditingController,
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

              // showGeneralDialog(
              //     context: context,
              //     pageBuilder: (BuildContext buildContext,
              //         Animation<double> animation,
              //         Animation<double> secondaryAnimation) {
              //       final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
              //       final Widget pageChild = Builder(builder: (context) {
              //         return StatefulBuilder(builder: (context, StateSetter state) {
              //           return FocusNodeDemoPage();
              //         });
              //       });
              //       return Builder(builder: (BuildContext context) {
              //         return theme != null
              //             ? Theme(data: theme, child: pageChild)
              //             : pageChild;
              //       });
              //     },
              //   barrierDismissible: true,
              //   barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
              //   barrierColor: Colors.black54,
              //   transitionDuration: const Duration(milliseconds: 300),
              //   transitionBuilder: (
              //       BuildContext context,
              //       Animation<double> animation,
              //       Animation<double> secondaryAnimation,
              //       Widget child,
              //       ) =>
              //       SlideTransition(
              //         position: Tween<Offset>(
              //           begin: const Offset(0, 1),
              //           end: Offset.zero,
              //         ).animate(animation),
              //         child: child,
              //       ),
              // );
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
