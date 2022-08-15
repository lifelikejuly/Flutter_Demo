import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TestHowToRefreshUIDemo extends StatefulWidget {
  @override
  State<TestHowToRefreshUIDemo> createState() => _TestHowToRefreshUIDemoState();
}

class _TestHowToRefreshUIDemoState extends State<TestHowToRefreshUIDemo> {
  int allNum = 0;


  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {

    });
    SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {

    });
    SchedulerBinding.instance.addTimingsCallback((timings) {

    });
  }

  @override
  Widget build(BuildContext context) {
    print("<> build _TestHowToRefreshUIDemoState");
    return GestureDetector(
      child: Container(
        color: Colors.blueGrey,
        child: Column(
          children: [
            Text("allNum $allNum"),
            TestRefreshUI1(allNum),
            TestRefreshUI2(),
            TestRefreshUI3(),
          ],
        ),
      ),
      onTap: () {
        setState(() {});
      },
    );
  }
}

class TestRefreshUI1 extends StatefulWidget {
  int allNum;

  @override
  State<TestRefreshUI1> createState() => _TestRefreshUI1State();

  TestRefreshUI1(this.allNum);
}

class _TestRefreshUI1State extends State<TestRefreshUI1> {
  int num = 0;

  @override
  Widget build(BuildContext context) {
    num++;
    print("<> build _TestRefreshUI1State");
    return Container(
      color: Colors.red,
      height: 70,
      child: GestureDetector(
        child: Text("TestRefreshUI1 build $num ${widget.allNum}"),
        onTap: () {
          widget.allNum++;
          setState(() {});
        },
      ),
    );
  }
}

class TestRefreshUI2 extends StatelessWidget {
  int num = 0;

  @override
  Widget build(BuildContext context) {
    num++;
    print("<> build TestRefreshUI2 ");
    return GestureDetector(
      child: Container(
        color: Colors.amber,
        height: 70,
        child: Text("TestRefreshUI2 build $num"),
      ),
      onTap: () {},
    );
  }
}

class TestRefreshUI3 extends StatelessWidget {
  int num = 0;

  @override
  Widget build(BuildContext context) {
    num++;
    print("<> build TestRefreshUI3 build");
    return Container(
      child: TestRefreshUI3Child(),
    );
  }
}

class TestRefreshUI3Child extends StatefulWidget {
  @override
  State<TestRefreshUI3Child> createState() => _TestRefreshUI3ChildState();
}

class _TestRefreshUI3ChildState extends State<TestRefreshUI3Child> {
  int num = 0;

  @override
  Widget build(BuildContext context) {
    num++;
    print("<> build _TestRefreshUI3ChildState ");
    return Container(
      color: Colors.blue,
      height: 70,
      child: GestureDetector(
        child: Text("TestRefreshUI3Child build $num"),
        onTap: () {
          setState(() {});
        },
      ),
    );
  }
}
