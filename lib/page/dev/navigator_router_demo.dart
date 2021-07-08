import 'package:flutter/material.dart';
import 'package:flutter_demo/base/base_widget_ui.dart';
import 'package:flutter_demo/home_page.dart';
import 'package:flutter_demo/main.dart';

// 路由页面信息测试

class NavigatorRouterDemo extends StatefulWidget {
  final String content;

  NavigatorRouterDemo({this.content});

  @override
  _NavigatorRouterDemoState createState() => _NavigatorRouterDemoState();
}

class _NavigatorRouterDemoState extends State<NavigatorRouterDemo> {


  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: <Widget>[
          FlatButton(onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                  BaseViewPage("路由信息测试", NavigatorRouterDemo(content: this.toString(),))
              ),
            );

          }, child: Text(widget.content ?? "null")),

          FlatButton(onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                settings: RouteSettings(name: "kkk",arguments: {"ll":"lll"}),
                  builder: (BuildContext context) =>
                      BaseViewPage("路由信息测试", NavigatorRouterDemo(content: this.toString(),))
              ),
            );

          }, child: Text("${widget.content} - 2" ?? "null - 2")),
          FlatButton(onPressed: () {
                Navigator.of(context).pushNamed("/router/NavigatorRouterDemo");
          }, child: Text("routName")),
          FlatButton(
            onPressed: (){
              RouteInfo routerInfo = findRoute();
              do{
                if(routerInfo != null && routerInfo.current != null){
                  print("<> name: ${routerInfo?.current?.settings?.name} ");
                  print("<> arguments: ${routerInfo?.current?.settings?.arguments} ");
                  print("<> Navigator: ${routerInfo?.parentNavigator?.toString()} ");
                  print("<> current: ${routerInfo?.current?.toString()} \n");

                }
                routerInfo = routerInfo?.parent;
              }while(routerInfo != null);
            },
            child: Text("test"),
          ),
        ],
      ),
    );
  }



  RouteInfo findRoute() {
    Element topElement;
    var context = MyApp.appKey.currentContext;
    if (context == null) return null;
    final ModalRoute rootRoute = ModalRoute.of(context);

    void listTopView(Element element) {
      if (element.widget is! PositionedDirectional) {
        if (element is RenderObjectElement &&
            element.renderObject is RenderBox) {
          final ModalRoute route = ModalRoute.of(element);
          if (route != null && route != rootRoute) {
            topElement = element;
          }
        }
        element.visitChildren(listTopView);
      }
    }

    context.visitChildElements(listTopView);

    if (topElement != null) {
      final RouteInfo routeInfo = RouteInfo();
      routeInfo.current = ModalRoute.of(topElement);
      buildNavigatorTree(topElement, routeInfo);
      return routeInfo;
    }
    return null;
  }

  // 递归遍历获取所有路由信息
  void buildNavigatorTree(Element element, RouteInfo routeInfo) {
    print("<> buildNavigatorTree");
    final NavigatorState navigatorState =
    element.findAncestorStateOfType<NavigatorState>();
    if (navigatorState != null) {
      final RouteInfo parent = RouteInfo();
      parent.current = ModalRoute.of(navigatorState.context);
      routeInfo.parent = parent;
      routeInfo.parentNavigator = navigatorState.widget;
      return buildNavigatorTree(navigatorState.context as Element, parent);
    }
  }



}

class RouteInfo{
  ModalRoute current;
  Widget parentNavigator;
  RouteInfo parent;
}



class NavigatorPage extends StatefulWidget {
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: NavigatorRouterDemo(),
    );
  }
}

