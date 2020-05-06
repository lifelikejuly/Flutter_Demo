import 'package:flutter/material.dart';

class StatelessLifecycleDemo extends StatelessWidget {


  final String TAG = "StatelessLifecycleDemo";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }

  StatelessLifecycleDemo(){
    print("$TAG StatelessLifecycleDemo constructor");
  }


}
