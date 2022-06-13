import 'package:flutter/material.dart';

class HttpDemo extends StatefulWidget {
  @override
  _HttpDemoState createState() => _HttpDemoState();
}

class _HttpDemoState extends State<HttpDemo> {
  String content = "";

  @override
  void initState() {
    super.initState();
    // HNetClient.BASE_URL = "http://gank.io";
  }

  _getReponse() async {
    // HDialogUtil.showLoadingDialog(context);
    // var response = await HNetClient.get("/api/xiandu/categories", {});
    // if (response != null) {
    //   setState(() {
    //     content = response.toString();
    //   });
    // }
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RaisedButton(
          child: Text("GET"),
          onPressed: () {
            _getReponse();
          },
        ),
        Text(content),
      ],
    );
  }
}
