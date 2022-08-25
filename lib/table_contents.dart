import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/page/dev/clippath_image_shape_demo.dart';
import 'package:flutter_demo/page/dev/complex_page_demo2.dart';
import 'package:flutter_demo/page/dev/crash_demo.dart';
import 'package:flutter_demo/page/dev/gif_play_one_bug_demo.dart';
import 'package:flutter_demo/page/dev/horizontal_wrap_barrage_demo.dart';
import 'package:flutter_demo/page/dev/list_scrool_change_demo.dart';
import 'package:flutter_demo/page/dev/one_line_warp_demo.dart';
import 'package:flutter_demo/page/dev/page_cache_demo.dart';
import 'package:flutter_demo/page/dev/reuse_key_list_demo.dart';
import 'package:flutter_demo/page/dev/secondfloor/refresh_keep_second_floor_demo.dart';
import 'package:flutter_demo/page/dev/sliver_border_demo.dart';
import 'package:flutter_demo/page/dev/sliver_customer_demo.dart';
import 'package:flutter_demo/page/dev/tabbar_add_jump_demo.dart';
import 'package:flutter_demo/page/dev/textField_focus_demo.dart';
import 'package:flutter_demo/page/diy/circlelist/circle_list_demo.dart';
import 'package:flutter_demo/page/diy/download/download_demo.dart';
import 'package:flutter_demo/page/diy/draggridview/diy_drag_gridview_demo.dart';
import 'package:flutter_demo/page/diy/emoji/emoji_demo.dart';
import 'package:flutter_demo/page/diy/wheel/list_wheel_diy_demo.dart';
import 'package:flutter_demo/page/func/func_matrix4_demo.dart';
import 'package:flutter_demo/page/layout/test_how_to_refresh_ui_demo.dart';
import 'package:flutter_demo/page/lib/extened_nested_scroll_view_demo.dart';
import 'package:flutter_demo/page/lib/photo_view_demo.dart';

import 'contents/widget.dart';
import 'demo/texture/texture_main_demo.dart';
import 'page/dart/future_wait_demo.dart';
import 'page/dart/map_demo.dart';
import 'page/dart/stream_demo.dart';
import 'page/dev/flex_tabbar_page_demo1/complex_page_demo1.dart';
import 'page/dev/image_combined_animation_demo.dart';
import 'page/dev/list_jump_init_demo.dart';
import 'page/dev/scale_widget_demo.dart';
import 'page/dev/sliver_refresh_demo.dart';
import 'page/diy/appbar/custom_app_bar_demo.dart';
import 'page/diy/carousel/carousel_demo.dart';
import 'page/diy/draglistview/sliver_reorder_listview_demo.dart';
import 'page/diy/preview/image_preview_animation_demo.dart';
import 'page/diy/refresh/custom_refresh_demo.dart';
import 'page/diy/shoppage/shop_page_demo.dart';
import 'page/diy/tabbar/diy_tabbar_demo.dart';
import 'page/func/func_matrix4_pentagon_demo.dart';
import 'page/func/func_matrix4_u_demo.dart';
import 'page/lib/over_nested_scroll_demo.dart';
import 'simple_import.dart';

class TableContents {
  // 自定义功能实现
  static Map<String, Widget> DIYDemos = {
    "翻页效果Flip": FlipDemo(),
    "抽屉效果Drawer": DrawerDemo(),
    "轮播效果BubbleCarousel": CarouselDemo(),
    "拖拽移动九宫格DragGridView": DragGridViewDemo(),
    "拖拽移动列表DragListView": SliverReorderListViewDemo(),
    "大图预览交互效果FullSizePreviewImage":ImagePreviewAnimationDemo(),
    "自定义Emoji": EmojiDemo(),
    "图片外接纹理": TextureMainDemo(),
    "圆形环绕列表": CircleListDemo(),
    "自定义ListWheel": ListWheelDiyDemo(),
    "自定义TabBarView(主题色功能)": DiyTabbarDemo(),
    "自定义频道页(主题色功能)":CustomAppBarDemo(),
    "下载组件实现": DownloadDemo(),
    "自定义下拉刷新组件":CustomRefreshDemo(),
    // "自定义主体框架页面": ShopPageDemo(),
  };

  // 开发真实案例
  static Map<String, Widget> DevDemos = {
    "NestedScroll定制化页面": NestedScrollPageDemo(),
    "AppBar吸顶效果+TabBar列表": NestedScrollTabBarListDemo(),
    "顶部Bar吸顶效果": BarSnapDemo(),
    "列表滑动的阻尼效果自定义": DIYScrollDemo(),
    "Gif控制播放": GifPlayerDemo(),
    "Text组件中英文组合显示": TextChineseEnglishDemo(),
    "TabBar原生切换动效去抖": TabBarSwitchDemo(),
    "侧滑拉取获取更多": SidePullDemo(), // 借鉴refresh组件改造
    "MethodChannel调用": NativeDemo(),
    "Webp加载bug": WebpBugDemo(),
    "Text和Icon一行问题": RowTextWithIconDemo(),
    "悬浮框功能": CommonWidgetDemo({
      "Stack组件模式": FloatStackDemo(),
      "Draggable组件模式": FloatDraggableDemo(),
      "OverlayEntry组件模式": FloatOverLayDemo(),
    }),
    "PageView排查缓存问题": PageCacheDemo(),
    "自定义SliverRefreshControl效果": SliverRefreshDemo(),
    "List初始化创建过程问题": ListJumpInitDemo(),
    "Tabbar动态变化以及定位问题": TabBarAddJumpDemo(),
    "Sliver支持添加边框的问题": SliverBorderDemo(),
    "Sliver自定义UI组件": SliverCustomerDemo(),
    "Warp组件只保留一行数据": OneLineWrapDemo(),
    "复杂页面交互布局实战Demo1": ComplexPageDemo1(),
    "页面结构实战Demo2": StickyTabsPage(),
    "Key复用导致的问题": ReuseKeyListDemo(),
    "Gif图片有Loop只播放一次不显示问题": GifPlayOnceBugDemo(),
    "图片放大预览交互效果动画": ImageCombinedAnimationDemo(),
    "listview实现的弹幕效果": HorizontalWrapBarrageDemo(),
    "Clip裁切": ClippathImageShapeDemo(),
    "缩放动画": ScaleWidgetDemo(),
    "列表滚动改造": ListScrollChangeDemo(),
    // "下拉刷新上二楼效果": RefreshKeepDemo(),
  };



  // 第三方库使用
  static Map<String, Widget> OpenLibDemos = {
    "瀑布流staggered": StaggeredDemo(),
    "瀑布流waterfall": WaterFallDemo(),
    "图表Charts": ChartsDemo(),
    "轮播Swiper": SwiperDemo(),
    "图片cache_image": CacheImageDemo(),
    "刷新SmartRefresher": RefreshDemo(),
    "全局管理Redux": ReduxDemo(),
    "FishRedux开发": FishReduxDemo(),
    "视频播放VideoPlayer": VideoDemo(),
    "网络请求库Dio": HttpDemo(),
    "套接字WebSocket": HttpServerDemo(),
    "效果轮播transformer": TransformerPageDemo(),
    "动效lottie": LottieDemo(),
    "Gif播放控制flutter_gifimage": GifControllerDemo(),
    "图片阅读器photo_view": PhotoViewDemo(),
    "extended_nested_scroll_view": OldExtendedNestedScrollViewDemo(),
    "OverNestedScrollDemo":OverNestedScrollDemo(),
  };

  // 基础技术方案
  static Map<String, Widget> BaseSkillDemos = {
    // "路由检查页面": NavigatorRouterDemo(),
    "Crash错误捕捉":CrashDemo(),
    "刷新机制":TestHowToRefreshUIDemo(),
  };

  static Map<String, Widget> DartDemos = {
    "Map集合类型添加的异常": MapDemo(),
    "Stream使用": StreamDemo(),
    "Future wait使用": FutureWaitDemo(),
  };

  static Map<String, Widget> FuncDemos = {
    "Matrix4实用": FuncMatrix4Demo(),
    "Matrix4五边形": FuncMatrix4PentagonDemo(),
    "Matrix4特殊U": FuncMatrix4UDemo(),
    "输入框和软键盘的使用": TextFieldFocusDemo(),
  };


  static Map<String, Map<String, Widget>> tables = {
    "自定义功能": DIYDemos,
    "开发实战案例": DevDemos,
    "组件学习": LearnWidget.WidgetDemos,
    "第三方库": OpenLibDemos,
    "Dart语法相关": DartDemos,
    "基础技术相关":BaseSkillDemos,
    "方法使用":FuncDemos,
  };
}
