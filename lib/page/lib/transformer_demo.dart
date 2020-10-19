import 'package:flutter/material.dart';
import 'package:flutter_demo/magic/diy_tabs.dart';
import 'package:flutter_demo/mock/img_mock.dart';

class TransformerPageDemo extends StatefulWidget {
  @override
  _TransformerPageDemoState createState() => _TransformerPageDemoState();
}

class _TransformerPageDemoState extends State<TransformerPageDemo>
    with TickerProviderStateMixin {
  final List<String> titles = [
    "Welcome",
    "Simple to use",
    "Easy parallax",
    "Customizable"
  ];
  final List<String> subtitles = [
    "Flutter TransformerPageView, for welcome screen, banner, image catalog and more",
    "Simple api,easy to understand,powerful adn strong",
    "Create parallax by a few lines of code",
    "Highly customizable, the only boundary is our mind. :)"
  ];

  List<String> tabs = [
    "关注",
    "发现",
    "明星饭圈",
    "寻味指南",
    "史莱姆",
    "妈咪宝贝",
    "汉服同袍",
  ];

  List<Widget> tabWidgets;
  List<Widget> tabPageViews;
  TabController tabController1;

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.blue,
    Colors.amber,
    Colors.cyan,
    Colors.pink
  ];

  Color getRandomColor(int index) {
    return colors.elementAt(index);
  }

  int index = 0;

  TabController indexController;

//  PageController pageController;
  PageController pageController1;

  @override
  void initState() {
    super.initState();
//    pageController = PageController(
//      initialPage: 0,
//    );
    pageController1 = PageController(initialPage: 0);
    tabWidgets = List();
    tabPageViews = List();
    tabs.forEach((element) {
      tabWidgets.add(Stack(
        children: <Widget>[
          Container(
            height: 50,
            padding: EdgeInsets.only(right: 12, left: 12),
            child: Text(
              element,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ));
      int index = tabs.indexOf(element);
      Color color = getRandomColor(index);
      tabPageViews.add(
        Container(
          color: color,
          child: Center(
            child: Text(
              element,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
    tabController1 = TabController(
      initialIndex: 0,
      length: tabs.length,
      vsync: this,
    );

    pageController1.addListener(() {
//      print("tabController1 ${pageController1.offset}");
//      pageController.jumpTo(pageController1.offset);
    });
//    pageController.addListener(() {
//      print("pageController ${pageController.offset}");
//    });
  }

  @override
  Widget build(BuildContext context) {
    print("build ${MediaQuery.of(context).size.width * 2}");
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          bottom: 0,
          child: Row(
            children: <Widget>[
              FlatButton(
                child: Text("<"),
                onPressed: () {
                  index -= 1;
                  index = index >= 0 ? index : 0;
                  indexController.animateTo(index);
                },
              ),
              FlatButton(
                child: Text(">"),
                onPressed: () {
                  index += 1;
                  index = index <= 3 ? index : 3;
                  indexController.animateTo(index);
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                DIYTabBar(
                  tabs: tabWidgets,
                  controller: tabController1,
                  isScrollable: true,
                  labelColor: Color(0xFF333333),
                  unselectedLabelColor: Color(0xFF333333),
                  labelPadding: EdgeInsets.all(0),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                  ),
                  labelStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                Expanded(
                  child: DIYBarView(
                    controller: tabController1,
                    children: tabPageViews,
                    pageController: pageController1,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          child: AnimatedBuilder(
            animation: pageController1,
            builder: (context, widget) {
              double page = pageController1?.page ?? 0;
              int realPage = pageController1?.page?.floor() ?? 0;
              double opacity = 1 - (page - realPage).abs();
              Widget child = Stack(
                children: <Widget>[
                  Opacity(
                    opacity: opacity,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      color: colors[realPage],
                    ),
                  ),
                  Opacity(
                    opacity: 1 - opacity,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      color: colors[realPage + 1],
                    ),
                  ),
                  Opacity(
                    opacity: opacity,
                    child: Image.network(
                      mockImgs[realPage],
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Opacity(
                    opacity: 1 - opacity,
                    child: Image.network(
                      mockImgs[realPage + 1],
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              );
              return child;
            },
          ),
        )
      ],
    );
  }
}
