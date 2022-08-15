import 'package:flutter/material.dart';

class FutureWaitDemo extends StatefulWidget {

  @override
  State<FutureWaitDemo> createState() => _FutureWaitDemoState();
}

class _FutureWaitDemoState extends State<FutureWaitDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: Text("wait"),
        onTap: () async{
          int time = DateTime.now().millisecondsSinceEpoch;
          print("<> todoWait start");
          await todoWait();
          print("<> todoWait end ${DateTime.now().millisecondsSinceEpoch - time}");
        },
      ),
    );
  }



  todoWait() async{

    Future<void> _wait1() async{
      return Future.delayed(Duration(seconds: 2),(){
        print("<> todoWait _wait1 end");
      });
    }

    Future<void> _wait3() async{
      return Future.delayed(Duration(seconds: 3),(){
        print("<> todoWait _wait3 end");
      });
    }

    Future<void> _wait2() async{
      return Future.delayed(Duration(seconds: 4),(){
        print("<> todoWait _wait2 end");
      });
    }

    List<Future> futures = [];
    futures.add(_wait1());
    futures.add(_wait2());
    futures.add(_wait3());
    return Future.wait(futures);
  }
}
