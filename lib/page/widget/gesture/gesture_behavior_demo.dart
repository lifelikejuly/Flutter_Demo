import 'package:flutter/material.dart';

class GestureBehaviorDemo extends StatefulWidget {
  @override
  _GestureBehaviorDemoState createState() => _GestureBehaviorDemoState();
}

class _GestureBehaviorDemoState extends State<GestureBehaviorDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: ParentGestureCell(ChildGestureCell("opaque")),
            onTap: () {
              print("<> GestureDetector opaque");
            },
          ),
          SizedBox(height: 50),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: ParentGestureCell(ChildGestureCell("translucent")),
            onTap: () {
              print("<> GestureDetector translucent");
            },
          ),
          SizedBox(height: 50),
          GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            child: ParentGestureCell(ChildGestureCell("deferToChild")),
            onTap: () {
              print("<> GestureDetector deferToChild");
            },
          ),
          SizedBox(height: 50),
          // 使用Listener 父类子类同时接受点击
          Listener(
            behavior: HitTestBehavior.opaque,
            child: ParentGestureCell(
              Listener(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      color: Colors.red,
                      child: Text("Listener"),
                    )
                  ],
                ),
                onPointerDown: (event) {
                  print("<> Listener childCell onPointerDown");
                },
              ),
            ),
            onPointerDown: (event) {
              print("<> Listener onPointerDown");
            },
          ),

          SizedBox(height: 50),
          // 使用AbsorbPointer 父类可拦截点击 子类不可点击
          GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            child: ParentGestureCell(AbsorbPointer(
              child: ChildGestureCell("AbsorbPointer"),
            )),
            onTap: () {
              print("<> GestureDetector AbsorbPointer");
            },
          ),
          SizedBox(height: 50),
          // 当子类具有点击能力，父类点击失效

          // GestureDetector(
          //   behavior: HitTestBehavior.opaque,
          //   child: ParentGestureCell(ChildGestureCellNUll("opaque")),
          //   onTap: (){
          //     print("<> GestureDetector opaque");
          //   },
          // ),
          // SizedBox(height: 50),
          // GestureDetector(
          //   behavior: HitTestBehavior.translucent,
          //   child: ParentGestureCell(ChildGestureCellNUll("translucent")),
          //   onTap: (){
          //     print("<> GestureDetector translucent");
          //   },
          // ),
          // SizedBox(height: 50),
          // GestureDetector(
          //   behavior: HitTestBehavior.deferToChild,
          //   child:  ParentGestureCell(ChildGestureCellNUll("deferToChild")),
          //   onTap: (){
          //     print("<> GestureDetector deferToChild");
          //   },
          // ),
        ],
      ),
    );
  }
}

class ParentGestureCell extends StatelessWidget {
  final Widget child;

  ParentGestureCell(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 200,
      child: child,
      color: Colors.blue,
    );
  }
}

class ChildGestureCellNUll extends StatelessWidget {
  final String text;

  ChildGestureCellNUll(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 100,
          width: 100,
          color: Colors.red,
          child: Text(text),
        )
      ],
    );
  }
}

class ChildGestureCell extends StatelessWidget {
  final String text;

  ChildGestureCell(this.text);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            color: Colors.red,
            child: Text(text),
          )
        ],
      ),
      onTap: () {
        print("<> ChildGestureCell $text");
      },
    );
  }
}
