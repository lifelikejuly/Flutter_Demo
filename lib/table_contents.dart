import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/page/dev/bar_snap_demo.dart';
import 'package:flutter_demo/page/dev/gif_player_demo.dart';
import 'package:flutter_demo/page/dev/side_pull_demo.dart';
import 'package:flutter_demo/page/dev/tabbar_switch_demo.dart';
import 'package:flutter_demo/page/dev/text_chinese_english_demo.dart';
import 'package:flutter_demo/page/lib/staggered_demo.dart';
import 'package:flutter_demo/page/lib/waterfall_demo.dart';
import 'package:flutter_demo/page/widget/common_widget_demo.dart';
import 'package:flutter_demo/page/widget/sliver/sliver_grid_demo.dart';
import 'package:flutter_demo/page/widget/sliver/sliver_list_demo.dart';
import 'package:flutter_demo/page/widget/sliver/sliver_prototype_extentList_demo.dart';


class TableContents {
  // 自定义功能实现
  static Map<String, Widget> DIYDemos = {
//    "ListView实现轮播": "",
  };

  // 开发真实案例
  static Map<String, Widget> DevDemos = {
    "顶部Bar吸顶效果": BarSnapDemo(),
    "Gif控制播放": GifPlayerDemo(),
    "Text组件中英文组合显示": TextChineseEnglishDemo(),
    "TabBar切换动效": TabBarSwitchDemo(),
    "侧滑拉取获取更多": SidePullDemo(), // 借鉴refresh组件改造
  };

  // 组件学习
  static Map<String, Widget> WidgetDemos = {
//    "画布Canvas": "",
//    "图片Image": "",
    "Sliver组件": CommonWidgetDemo(SliverWidgetDemos),
  };

  static Map<String, Widget> SliverWidgetDemos = {
    "SliverList": SliverListDemo(),
    "SliverGrid": SliverGridDemo(),
    "SliverPrototypeExtentList": SliverPrototypeExtentListDemo(),
  };

  // 第三方库使用
  static Map<String, Widget> OpenLibDemos = {
    "瀑布流staggered": StaggeredDemo(),
    "瀑布流waterfall": WaterFallDemo(),
  };

  static Map<String, Map<String, Widget>> tables = {
    "自定义功能": DIYDemos,
    "开发实战案例": DevDemos,
    "组件学习": WidgetDemos,
    "第三方库": OpenLibDemos,
  };
}
