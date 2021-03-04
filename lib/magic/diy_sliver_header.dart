

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DIYSliverPersistentHeader extends StatelessWidget {
  const DIYSliverPersistentHeader({
    Key key,
    this.delegate,
    this.pinned = false,
    this.floating = false,
  }) : assert(delegate != null),
        assert(pinned != null),
        assert(floating != null),
        super(key: key);

  final SliverPersistentHeaderDelegate delegate;

  final bool pinned;

  final bool floating;

  @override
  Widget build(BuildContext context) {
      return _SliverFloatingPinnedPersistentHeader(delegate: delegate);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<SliverPersistentHeaderDelegate>(
          'delegate',
          delegate,
        )
    );
    final List<String> flags = <String>[
      if (pinned) 'pinned',
      if (floating) 'floating',
    ];
    if (flags.isEmpty)
      flags.add('normal');
    properties.add(IterableProperty<String>('mode', flags));
  }
}


class _SliverFloatingPinnedPersistentHeader extends _SliverPersistentHeaderRenderObjectWidget {
  const _SliverFloatingPinnedPersistentHeader({
    Key key,
    @required SliverPersistentHeaderDelegate delegate,
  }) : super(
    key: key,
    delegate: delegate,
  );

  @override
  _RenderSliverPersistentHeaderForWidgetsMixin createRenderObject(BuildContext context) {
    return _RenderSliverFloatingPinnedPersistentHeaderForWidgets(
      snapConfiguration: delegate.snapConfiguration,
      stretchConfiguration: delegate.stretchConfiguration,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSliverFloatingPinnedPersistentHeaderForWidgets renderObject) {
    renderObject.snapConfiguration = delegate.snapConfiguration;
    renderObject.stretchConfiguration = delegate.stretchConfiguration;
  }
}

abstract class _SliverPersistentHeaderRenderObjectWidget extends RenderObjectWidget {
  const _SliverPersistentHeaderRenderObjectWidget({
    Key key,
    this.delegate,
  }) : assert(delegate != null),
        super(key: key);

  final SliverPersistentHeaderDelegate delegate;

  @override
  _SliverPersistentHeaderElement createElement() => _SliverPersistentHeaderElement(this);

  @override
  _RenderSliverPersistentHeaderForWidgetsMixin createRenderObject(BuildContext context);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(
        DiagnosticsProperty<SliverPersistentHeaderDelegate>(
          'delegate',
          delegate,
        )
    );
  }
}

class _SliverPersistentHeaderElement extends RenderObjectElement {
  _SliverPersistentHeaderElement(_SliverPersistentHeaderRenderObjectWidget widget) : super(widget);

  @override
  _SliverPersistentHeaderRenderObjectWidget get widget => super.widget as _SliverPersistentHeaderRenderObjectWidget;

  @override
  _RenderSliverPersistentHeaderForWidgetsMixin get renderObject => super.renderObject as _RenderSliverPersistentHeaderForWidgetsMixin;

  @override
  void mount(Element parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    renderObject._element = this;
  }

  @override
  void unmount() {
    super.unmount();
    renderObject._element = null;
  }

  @override
  void update(_SliverPersistentHeaderRenderObjectWidget newWidget) {
    final _SliverPersistentHeaderRenderObjectWidget oldWidget = widget;
    super.update(newWidget);
    final SliverPersistentHeaderDelegate newDelegate = newWidget.delegate;
    final SliverPersistentHeaderDelegate oldDelegate = oldWidget.delegate;
    if (newDelegate != oldDelegate &&
        (newDelegate.runtimeType != oldDelegate.runtimeType || newDelegate.shouldRebuild(oldDelegate)))
      renderObject.triggerRebuild();
  }

  @override
  void performRebuild() {
    super.performRebuild();
    renderObject.triggerRebuild();
  }

  Element child;

  void _build(double shrinkOffset, bool overlapsContent) {
    owner.buildScope(this, () {
      child = updateChild(
        child,
        widget.delegate.build(
            this,
            shrinkOffset,
            overlapsContent
        ),
        null,
      );
    });
  }

  @override
  void forgetChild(Element child) {
    assert(child == this.child);
    this.child = null;
    super.forgetChild(child);
  }

  @override
  void insertChildRenderObject(covariant RenderBox child, dynamic slot) {
    assert(renderObject.debugValidateChild(child));
    renderObject.child = child;
  }

  @override
  void moveChildRenderObject(covariant RenderObject child, dynamic slot) {
    assert(false);
  }

  @override
  void removeChildRenderObject(covariant RenderObject child) {
    renderObject.child = null;
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    if (child != null)
      visitor(child);
  }
}

mixin _RenderSliverPersistentHeaderForWidgetsMixin on RenderSliverPersistentHeader {
  _SliverPersistentHeaderElement _element;

  @override
  double get minExtent => _element.widget.delegate.minExtent;

  @override
  double get maxExtent => _element.widget.delegate.maxExtent;

  @override
  void updateChild(double shrinkOffset, bool overlapsContent) {
    assert(_element != null);
    _element._build(shrinkOffset, overlapsContent);
  }

  @protected
  void triggerRebuild() {
    markNeedsLayout();
  }
}

class _RenderSliverFloatingPinnedPersistentHeaderForWidgets extends RenderSliverFloatingPinnedPersistentHeader
    with _RenderSliverPersistentHeaderForWidgetsMixin {
  _RenderSliverFloatingPinnedPersistentHeaderForWidgets({
    RenderBox child,
    FloatingHeaderSnapConfiguration snapConfiguration,
    OverScrollHeaderStretchConfiguration stretchConfiguration,
  }) : super(
    child: child,
    snapConfiguration: snapConfiguration,
    stretchConfiguration: stretchConfiguration,
  );
}