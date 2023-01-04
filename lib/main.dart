import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter/scheduler.dart';
import 'package:flutter_demo/demo/router/router_data_demo.dart';
import 'package:flutter_demo/demo/router/router_demo.dart';
import 'package:flutter_demo/demo_page.dart';
import 'package:flutter_demo/page/dev/navigator_router_demo.dart';
import 'package:flutter_demo/page/lib/fishredux/demopage1/page.dart';
import 'package:flutter_demo/page/lib/fishredux/demopage2/page.dart';
import 'package:flutter_demo/page/lib/fishredux/demopage3/page.dart';
import 'package:flutter_demo/page/lib/fishredux/demopage4/page.dart';
import 'package:flutter_demo/ui/theme_demo.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart' as FlutterRedux;

import 'home_page.dart';
import 'page/lib/fishredux/list/page.dart';
import 'page/lib/flutter_redux_demo.dart';
import 'page/lib/redux_demo.dart';

String CRASH_TAG = "---CRASH_TAG--- ";

Future<Null> _reportError(dynamic error, dynamic stackTrace) {
  print('$CRASH_TAG --------_reportError -----');
  print('$CRASH_TAG Caught error: $error');
  print("$CRASH_TAG stackTrace: $stackTrace");
}

void main() {

  runZonedGuarded<Future<void>>(() async {
    runApp(ChangeNotifierProvider<ThemeNotifier>.value(
      //ChangeNotifierProvider调用value()方法，里面传出value和child
      value: ThemeNotifier(), //value设置了默认的Counter()
      child: MyApp(),
    ));
    /// 记录帧率信息
//    SchedulerBinding.instance.addTimingsCallback((timings) {
//      for (FrameTiming frameTiming in timings) {
//        println("addTimingsCallback ${frameTiming.toString()}");
//      }
//    });
//     SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//       println("addPostFrameCallback $timeStamp");
//     });
  }, (error, stackTrace) {
    /// Dart和Native层异常捕获
    _reportError(error, stackTrace);
    print('$CRASH_TAG -------- onError dumpErrorToConsole-----');
    FlutterError.dumpErrorToConsole(
        FlutterErrorDetails(exception: error, stack: stackTrace));
//    FlutterError.resetErrorCount();
//    FlutterError.dumpErrorToConsole(
//        FlutterErrorDetails(exception: error, stack: stackTrace));
  },
    /// 不知道是不是日志捕获用的
    // zoneSpecification: ZoneSpecification(print:(
    //     Zone self, ZoneDelegate parent, Zone zone, String line){
    //   print("<> line  lllkjjjj $line");
    // }),

  );

  /// 捕获Flutter层异常捕获
  final defaultOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details){
    try{
      defaultOnError(details);
    }catch(e,s){
      FlutterError.dumpErrorToConsole(FlutterErrorDetails(
        exception: e,
        stack: s,
      ));
    }
    print("$CRASH_TAG  --------run FlutterError.onError--------");
    print("${details.exception} ${details.stack}");
    FlutterError.resetErrorCount();
    FlutterError.dumpErrorToConsole(details);
  };

  /// widget构建异常捕获
  var _defaultErrorWidgetBuilder = ErrorWidget.builder;
  ErrorWidget.builder = (FlutterErrorDetails details) {
    print("$CRASH_TAG  --------run ErrorWidget.builder--------");
    print("${details.exception} ${details.stack}");
    return _defaultErrorWidgetBuilder(details);
  };
}


class MainEntry extends StatefulWidget {

  final Widget widget;
  static GlobalKey appKey = GlobalKey();

  MainEntry(this.widget):super(key: appKey);

  @override
  _MainEntryState createState() => _MainEntryState();
}

class _MainEntryState extends State<MainEntry> {
  @override
  Widget build(BuildContext context) {
    return widget.widget;
  }
}


class MyApp extends StatefulWidget {
  static bool isInDebugMode = true;
  static GlobalKey appKey = GlobalKey();
  static BuildContext mainContext;


  MyApp():super(key:appKey);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AbstractRoutes routes = PageRoutes(
    pages: <String, Page<Object, dynamic>>{
      /// 注册TodoList主页面
      'fishPage1': FishDemoPage1Page(),
      'fishPage2': FishDemoPage2Page(),
      'fishPage3': FishDemoListPagePage(),
      'fishPage4': masterPagePage(),
      'fishReduxDemo-adapter-list': DemoListAdapterPage(),
    },
  );

  FlutterRedux.Store<AppState> store;

  @override
  void initState() {
    super.initState();
    store = FlutterRedux.Store<AppState>(
      counterReducer,
      initialState: AppState(),
      middleware: [
//        (store,action,action2){
//
//        },
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    MyApp.mainContext = context;
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        navigatorObservers: [UserNavigatorObserver()],
        themeMode: Provider.of<ThemeNotifier>(context).isDark
            ? ThemeMode.dark
            : ThemeMode.light,
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
         '/router/NavigatorRouterDemo': (context) =>  NavigatorPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute<Object>(builder: (BuildContext context) {
            return routes.buildPage(settings.name, settings.arguments);
          });
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  static GlobalKey appKey = GlobalKey();
  MyHomePage({Key key, this.title}) : super(key: appKey);

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
    demos["网络"] = DemoPage("net");
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
    print("[UserNavigatorObserver] [didPop] route ${route?.toString()} \n"
        "previousRoute ${previousRoute?.toString()}");
    print("[UserNavigatorObserver] [didPop] _history: ${history.length}");

    ///调用Navigator.of(context).pop() 出栈时回调
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    history.add(route);

    print("[UserNavigatorObserver] [didPush] route ${route.toString()} } \n"
        "previousRoute ${previousRoute?.toString()}");
    print("[UserNavigatorObserver] [didPush] _history: ${history.length}");

    ///调用Navigator.of(context).push(Route()) 进栈时回调
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    super.didRemove(route, previousRoute);
    history.remove(route);
    print("[UserNavigatorObserver] [didRemove] route ${route?.toString()} \n"
        "previousRoute ${previousRoute?.toString()}");
    print("[UserNavigatorObserver] [didRemove] _history: ${history.length}");

    ///调用Navigator.of(context).removeRoute(Route()) 移除某个路由回调
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    history.remove(oldRoute);
    history.add(newRoute);
    print(
        "[UserNavigatorObserver] [didReplace] route ${newRoute?.toString()} \n"
        "previousRoute ${oldRoute?.toString()}");

    ///调用Navigator.of(context).replace( oldRoute:Route("old"),newRoute:Route("new)) 替换路由时回调
  }

  @override
  void didStartUserGesture(Route route, Route previousRoute) {
    super.didStartUserGesture(route, previousRoute);
    print(
        "[UserNavigatorObserver] [didStartUserGesture] route ${route.settings.toString()} \n"
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
