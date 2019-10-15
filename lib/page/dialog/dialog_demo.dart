import 'package:flutter/material.dart';
import 'package:flutter_template/flutter_temple.dart';

class DialogDemo extends StatefulWidget {
  @override
  _DialogDemoState createState() => _DialogDemoState();
}

class _DialogDemoState extends State<DialogDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView(
          children: <Widget>[
            RaisedButton(
              child: Text("showDialog"),
              onPressed: () {
                AppDialogUtil.showAlertDialog(
                  context,
                  [
                    FlatButton(
                      child: Text("ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                  barrierDismissible: false,
                );
              },
            ),
            RaisedButton(
              child: Text("showLoading"),
              onPressed: () {
                AppDialogUtil.showLoadingDialog(
                  context,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
