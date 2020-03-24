import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_demo/demo/router/router_data_demo.dart';
import 'package:flutter_demo/demo/router/router_demo.dart';
import 'package:flutter_demo/demo_page.dart';
import 'package:flutter_demo/page/http/http_demo.dart';
import 'package:flutter_demo/primeval/native_demo.dart';
import 'package:flutter_demo/ui/theme_demo.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider<ThemeNotifier>.value(
      //ChangeNotifierProvider调用value()方法，里面传出value和child
      value: ThemeNotifier(), //value设置了默认的Counter()
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [UserNavigatorObserver()],
      themeMode: Provider.of<ThemeNotifier>(context).isDark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      title: 'Flutter Demo',
      initialRoute: "/",
      routes: {
        "/router": (context) => RouterDemo(),
        "/router/next1": (context) => NextPage1(),
        "/router/next2": (context) => NextPage2(),
        "/router/next3": (context) => NextPage3(),
        "/router/next4": (context) => NextPage4(),
        "/router/next5": (context) => NextPage5(),
        "/router/data2": (context) => RouterChildDateDemo2(),
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  HashMap<String, Widget> demos = new HashMap();

  @override
  void initState() {
    super.initState();
    demos["网络"] = HttpDemo();
    demos["原生调用"] = NativeDemo();
    demos["UI"] = DemoPage("ui");
    demos["第三方组件库"] = DemoPage("part");
    demos["语法"] = DemoPage("dart");
    demos["其他"] = DemoPage("other");
    demos["生命周期"] = DemoPage("life");
    demos["路由"] = DemoPage("router");
    demos["画布"] = DemoPage("canvas");
    demos["悬浮窗"] = DemoPage("float");
    demos["手势操作"] = DemoPage("gesture");
    demos["动画"] = DemoPage("animation");
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: demos.entries.map((item) {
            return RaisedButton(
              child: Text(item.key),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => item.value,
                  ),
                );
              },
            );
          }).toList(),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("MyHomePage ${state.toString()} ");
//    if (state == AppLifecycleState.paused) {
//      // went to Background
//      print("MyHomePage Background");
//    }
//    if (state == AppLifecycleState.resumed) {
//      // came back to Foreground
//      print("MyHomePage  Foreground");
//    }
  }

  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    print("MyHomePage didHaveMemoryPressure");
  }
}

class UserNavigatorObserver extends NavigatorObserver {
  static List<Route<dynamic>> history = <Route<dynamic>>[];

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    history.remove(route);
    print("UserNavigatorObserver didPop route ${route?.settings.toString()} "
        "previousRoute ${previousRoute?.settings?.toString()}");
    print("UserNavigatorObserver didPop _history: ${history.length}");

    ///调用Navigator.of(context).pop() 出栈时回调
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    history.add(route);
    print("UserNavigatorObserver didPush route ${route.settings.toString()} "
        "previousRoute ${previousRoute?.settings?.toString()}");
    print("UserNavigatorObserver didPush _history: ${history.length}");

    ///调用Navigator.of(context).push(Route()) 进栈时回调
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    super.didRemove(route, previousRoute);
    history.remove(route);
    print("UserNavigatorObserver didRemove route ${route.settings.toString()} "
        "previousRoute ${previousRoute?.settings?.toString()}");
    print("UserNavigatorObserver didRemove _history: ${history.length}");

    ///调用Navigator.of(context).removeRoute(Route()) 移除某个路由回调
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    history.remove(oldRoute);
    history.add(newRoute);
    print(
        "UserNavigatorObserver didReplace route ${newRoute.settings.toString()} "
        "previousRoute ${oldRoute?.settings?.toString()}");

    ///调用Navigator.of(context).replace( oldRoute:Route("old"),newRoute:Route("new)) 替换路由时回调
  }

  @override
  void didStartUserGesture(Route route, Route previousRoute) {
    super.didStartUserGesture(route, previousRoute);
    print(
        "UserNavigatorObserver didStartUserGesture route ${route.settings.toString()} "
        "previousRoute ${previousRoute?.settings?.toString()}");

    ///iOS侧边手势滑动触发回调 手势开始时回调
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    print("UserNavigatorObserver didStopUserGesture ");

    ///iOS侧边手势滑动触发停止时回调 不管页面是否退出了都会调用
  }
}
