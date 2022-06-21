
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/demo/pageview/pageview_demo.dart';
import 'package:flutter_demo/page/widget/animation/clip_animation_demo.dart';
import 'package:flutter_demo/page/widget/animation/hero_animation_demo.dart';
import 'package:flutter_demo/page/widget/animation/scale_transition_animation_demo.dart';
import 'package:flutter_demo/page/widget/animation/size_transition_animation_demo.dart';
import 'package:flutter_demo/page/widget/canvas/canvas_circle_demo.dart';
import 'package:flutter_demo/page/widget/canvas/canvas_dash_board_demo.dart';
import 'package:flutter_demo/page/widget/gesture/gesture_behavior_demo.dart';
import 'package:flutter_demo/page/widget/image/big_height_image_demo.dart';
import 'package:flutter_demo/page/widget/image/image_page_view_demo.dart';
import 'package:flutter_demo/page/widget/image/image_view_demo.dart';
import 'package:flutter_demo/page/widget/layout/layout_flow_demo.dart';
import 'package:flutter_demo/page/widget/layout/layout_wrap_demo.dart';
import 'package:flutter_demo/page/widget/list/list_auto_scroll_demo.dart';
import 'package:flutter_demo/page/widget/tab/tabbar_view_demo.dart';
import 'package:flutter_demo/page/widget/text/text_align_demo.dart';
import 'package:flutter_demo/page/widget/text/text_with_icon_demo.dart';
import 'package:flutter_demo/simple_import.dart';

class LearnWidget{
  // 组件学习
  static Map<String, Widget> WidgetDemos = {
    "TabBar组件": CommonWidgetDemo(TabWidgetDemos),
    "Sliver组件": CommonWidgetDemo(SliverWidgetDemos),
    "Layout组件": CommonWidgetDemo(LayoutDemos),
    "List组件": CommonWidgetDemo(ListDemos),
    "Canvas组件": CommonWidgetDemo(CanvasWidgetDemos),
    "GestureDetector组件": CommonWidgetDemo(GestureDetectorDemos),
    "Text组件": CommonWidgetDemo(TextDemos),
    "Image组件": CommonWidgetDemo(ImageDemos),
    "Animation组件": CommonWidgetDemo(AnimationDemos)
  };

  // Tab组件
  static Map<String, Widget> TabWidgetDemos = {
    "TabBarView": TabBarViewDemo(),
    "PageView": PageViewDemo(),
  };

  // Sliver组件
  static Map<String, Widget> SliverWidgetDemos = {
    "SliverList": SliverListDemo(),
    "SliverGrid": SliverGridDemo(),
    "SliverPrototypeExtentList": SliverPrototypeExtentListDemo(),
  };

  // Layout组件
  static Map<String, Widget> LayoutDemos = {
    "Flow": LayoutFlowDemo(),
    "Wrap": LayoutWrapDemo(),
  };

  // Text组件
  static Map<String, Widget> TextDemos = {
    "Text文本水平居中": TextAlignDemo(),
    "Text和Icon": TextWithIconDemo(),
  };

  // 图片组件
  static Map<String, Widget> ImageDemos = {
    "图片加载": ImageViewDemo(),
    "长图加载": BigHeightImageDemo(),
    "PageView图片加载": ImagePageViewDemo(),
  };

  // Canvas组件
  static Map<String, Widget> CanvasWidgetDemos = {
    "抖音Logo绘制": CanvasDouyinDemo(),
    "仪表盘绘制": CanvasDashBoardDemo(),
    "贝塞尔曲线画圆绘制": CanvasCircleDemo(),
  };

  // GestureDetector组件
  static Map<String, Widget> GestureDetectorDemos = {
    "手势拖拽": GestureDragDemo(),
    "手势缩放": GestureScaleDemo(),
    "手势点击": GestureClickDemo(),
    "手势缩放1": GestureScaleDemo1(),
    "手势缩放2": GestureScaleDemo2(),
    "手势点击传递策略": GestureBehaviorDemo(),
  };

  // List组件
  static Map<String, Widget> ListDemos = {
    "ListWheelScrollView": ListWheelDemo(),
    "RefreshIndicator VS CupertinoSliverRefreshControl": ListPullRefreshDemo(),
    "ListAutoUnlimitedScrollView": ListAutoScrollDemo(),
  };

  // Animation组件
  static Map<String, Widget> AnimationDemos = {
    "Hero动画": HeroAnimationDemo(),
    "Clip动画": ClipAnimationDemo(),
    "ScaleTransition动画": ScaleTransitionAnimationDemo(),
    "SizeTransition动画": SizeTransitionAnimationDemo(),
  };
}