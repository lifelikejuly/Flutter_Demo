part of 'nested_scroll_view.dart';

enum CustomOverscroll {
  ///allow inner scroller to overscroll
  inner,

  ///allow outer scroller to overscroll
  outer,
}

class CustomNestedScrollView extends StatelessWidget {
  ///A NestedScrollView that supports outer scroller to top overscroll.
  ///
  /// **Does not support floatHeaderSlivers**
  ///
  ///```dart
  ///class Example extends StatelessWidget {
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return DefaultTabController(
  ///      length: 2,
  ///      child: Scaffold(
  ///        body: CustomNestedScrollView(
  ///          physics: BouncingScrollPhysics(),
  ///          overscrollType: CustomOverscroll.outer,
  ///          headerSliverBuilder: (context, innerScrolled) => <Widget>[
  ///            CustomSliverOverlapAbsorber(
  ///              overscrollType: CustomOverscroll.outer,
  ///              handle: CustomNestedScrollView.sliverOverlapAbsorberHandleFor(context),
  ///              sliver: SliverAppBar(
  ///                pinned: true,
  ///                stretch: true,
  ///                expandedHeight: 400,
  ///                flexibleSpace: FlexibleSpaceBar(
  ///                  centerTitle: true,
  ///                  title: Center(child: Text('Example')),
  ///                  background: Image.network(
  ///                    'https://pic1.zhimg.com/80/v2-fc35089cfe6c50f97324c98f963930c9_720w.jpg',
  ///                    fit: BoxFit.cover,
  ///                  ),
  ///                ),
  ///                bottom: TabBar(
  ///                  tabs: [
  ///                    Tab(child: Text('Tab1')),
  ///                    Tab(child: Text('Tab1')),
  ///                  ],
  ///                ),
  ///              ),
  ///            ),
  ///          ],
  ///          body: TabBarView(
  ///            children: [
  ///              CustomScrollView(
  ///                slivers: <Widget>[
  ///                  Builder(
  ///                    builder: (context) => CustomSliverOverlapInjector(
  ///                      overscrollType: CustomOverscroll.outer,
  ///                      handle: CustomNestedScrollView.sliverOverlapAbsorberHandleFor(context),
  ///                    ),
  ///                  ),
  ///                  SliverFixedExtentList(
  ///                    delegate: SliverChildBuilderDelegate(
  ///                      (_, index) => ListTile(
  ///                        key: Key('$index'),
  ///                        title: Center(
  ///                          child: Text('ListTile ${index + 1}'),
  ///                        ),
  ///                      ),
  ///                      childCount: 30,
  ///                    ),
  ///                    itemExtent: 50,
  ///                  ),
  ///                ],
  ///              ),
  ///              Center(
  ///                child: Text('Test'),
  ///              ),
  ///            ],
  ///          ),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///```
  const CustomNestedScrollView({
    Key key,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.physics,
    @required this.headerSliverBuilder,
    @required this.body,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scrollBehavior,
    this.overscrollType = CustomOverscroll.outer,
  }) : super(key: key);

  final ScrollController controller;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollPhysics physics;
  final _NestedScrollViewHeaderSliversBuilder headerSliverBuilder;
  final Widget body;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final String restorationId;
  final ScrollBehavior scrollBehavior;

  ///allow which scroller to overscroll
  final CustomOverscroll overscrollType;

  @override
  Widget build(BuildContext context) {
    return
      overscrollType == CustomOverscroll.outer
        ? NestedScrollViewX(
            controller: controller,
            scrollDirection: scrollDirection,
            reverse: reverse,
            physics: physics,
            headerSliverBuilder: headerSliverBuilder,
            body: body,
            dragStartBehavior: dragStartBehavior,
            floatHeaderSlivers: false, //does not support floatHeaderSlivers
            clipBehavior: clipBehavior,
            restorationId: restorationId,
            scrollBehavior: scrollBehavior,
          )
        :
    NestedScrollViewY(
            controller: controller,
            scrollDirection: scrollDirection,
            reverse: reverse,
            physics: physics,
            headerSliverBuilder: headerSliverBuilder,
            body: body,
            dragStartBehavior: dragStartBehavior,
            floatHeaderSlivers: false, //does not support floatHeaderSlivers
            clipBehavior: clipBehavior,
            restorationId: restorationId,
            scrollBehavior: scrollBehavior,
          );
  }

  static _SliverOverlapAbsorberHandle sliverOverlapAbsorberHandleFor(
      BuildContext context) {
    final target = context
        .dependOnInheritedWidgetOfExactType<_InheritedNestedScrollView>();
    assert(
      target != null,
      '_NestedScrollView.sliverOverlapAbsorberHandleFor must be called with a context that contains a _NestedScrollView.',
    );
    return target.state._absorberHandle;
  }
}

class CustomSliverOverlapAbsorber extends _SliverOverlapAbsorber {
  CustomSliverOverlapAbsorber({
    Key key,
    @required _SliverOverlapAbsorberHandle handle,
    Widget sliver,
    CustomOverscroll overscrollType = CustomOverscroll.outer,
  })  : _overscrollType = overscrollType,
        super(key: key, handle: handle, sliver: sliver);

  ///allow which scroller to overscroll
  final CustomOverscroll _overscrollType;

  @override
  _RenderSliverOverlapAbsorber createRenderObject(BuildContext context) {
    return
      _overscrollType == CustomOverscroll.outer
        ? _RenderSliverOverlapAbsorberX(handle: handle)
        :
    _RenderSliverOverlapAbsorberY(handle: handle);
  }
}

class CustomSliverOverlapInjector extends _SliverOverlapInjector {
  CustomSliverOverlapInjector({
    Key key,
    @required _SliverOverlapAbsorberHandle handle,
    Widget sliver,
    CustomOverscroll overscrollType = CustomOverscroll.outer,
  })  : _overscrollType = overscrollType,
        super(key: key, handle: handle, sliver: sliver);

  ///allow which scroller to overscroll
  final CustomOverscroll _overscrollType;

  @override
  _RenderSliverOverlapInjector createRenderObject(BuildContext context) {
    return _overscrollType == CustomOverscroll.outer
        ? _RenderSliverOverlapInjectorX(handle: handle)
        : _RenderSliverOverlapInjectorY(handle: handle);
    // return _RenderSliverOverlapInjectorY(handle: handle);
  }
}
