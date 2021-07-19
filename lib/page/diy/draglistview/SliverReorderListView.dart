import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef ReorderCallback = void Function(int oldIndex, int newIndex);

class SliverReorderListView extends SliverList {

  SliverReorderListView.count({
    Key key,
    @required List<Widget> children,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
    ReorderCallback onReorder,
    bool ignoringFeedbackSemantics = false,
    Widget tail,
    List<Widget> extraChildren,
  }) : super(
    key: key,
    delegate: SliverChildReorderListDelegate(children: children,extraChildren:extraChildren, tail: tail, onReorder: onReorder,ignoringFeedbackSemantics: ignoringFeedbackSemantics),
  );



  SliverChildReorderListDelegate get reorderDelegate => delegate as SliverChildReorderListDelegate;

  @override
  SliverMultiBoxAdaptorElement createElement() {
    return SliverReorderMultiBoxAdaptorElement(this);
  }
}

class SliverChildReorderListDelegate extends SliverChildDelegate {

  final List<Widget> children;

  final Widget tail;

  final ReorderCallback onReorder;

  final bool ignoringFeedbackSemantics;

  final List<Widget> extraChildren;

  SliverChildReorderListDelegate({this.children,this.extraChildren, this.tail, this.onReorder,this.ignoringFeedbackSemantics = false});

  @override
  int get estimatedChildCount => children.length + (tail == null ? 0 : 1);

  SliverReorderMultiBoxAdaptorElement _bindedElement;

  @override
  Widget build(BuildContext context, int index) {
    if (index == children.length && tail != null) {
      return tail;
    } else if (index >= children.length) {
      return null;
    }
    Widget extraCell;
    if(extraChildren != null && extraChildren.length > index){
      extraCell = extraChildren[index];
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return _bindedElement._wrap(context, children[index],extraCell, index, constraints,ignoringFeedbackSemantics);
      },
    );
  }

  @override
  bool shouldRebuild(SliverChildReorderListDelegate oldDelegate) {
    return children != oldDelegate.children;
  }

  void bindElement(SliverReorderMultiBoxAdaptorElement element) {
    _bindedElement = element;
    print("<> bindElement ${_bindedElement.toString()}");
  }
}

class SliverReorderMultiBoxAdaptorElement extends SliverMultiBoxAdaptorElement {
  SliverReorderMultiBoxAdaptorElement(SliverReorderListView widget) : super(widget) {
    widget.reorderDelegate.bindElement(this);
  }

  Key _dragging;

  int _dragStartIndex;

  int _currentIndex;

  @override
  void update(covariant SliverReorderListView newWidget) {
    newWidget.reorderDelegate.bindElement(this);
    super.update(newWidget);
  }

  Widget _wrap(BuildContext context, Widget toWrap,Widget extraChild, int index, BoxConstraints constraints,bool ignoringFeedbackSemantics) {
    assert(toWrap.key != null);

    void onDragStarted() {
      _dragging = toWrap.key;
      _dragStartIndex = index;
      _currentIndex = index;
      performRebuild();
    }

    void onDragEnded() {
      if (_dragStartIndex != _currentIndex) {
        if ((widget as SliverReorderListView).reorderDelegate.onReorder != null) {
          (widget as SliverReorderListView).reorderDelegate.onReorder(_dragStartIndex, _currentIndex);
        }
      }
      _dragStartIndex = null;
      _currentIndex = null;
      _dragging = null;
      performRebuild();
    }

    Widget buildDragTarget(BuildContext context, List<Key> acceptedCandidates, List<dynamic> rejectedCandidates) {

      Widget child = LongPressDraggable<Key>(
        maxSimultaneousDrags: 1,
        data: toWrap.key,
        ignoringFeedbackSemantics: ignoringFeedbackSemantics,
        feedback: Builder(builder: (BuildContext context) {
          return Container(
              constraints: constraints,
              child: Material(
                elevation: 6.0,
                child: toWrap,
              )
          );
        }),
        child: _dragging == toWrap.key ? const SizedBox() : ((extraChild != null && _dragging == null) ? Stack(children: <Widget>[toWrap,extraChild],) : toWrap),
        dragAnchor: DragAnchor.child,
        onDragStarted: onDragStarted,
        onDragCompleted: onDragEnded,
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          onDragEnded();
        },
      );

      return child;
    }

    return DragTarget<Key>(
      builder: buildDragTarget,
      onWillAccept: (Key toAccept) {
        //TODO, could add animation here

        if (_currentIndex != index && _currentIndex != null) {
          List<Widget> children = (widget as SliverReorderListView).reorderDelegate.children;
          Widget temp = children.removeAt(_currentIndex);
          children.insert(index, temp);

        }
        _currentIndex = index;

        performRebuild();
        //TODO, scroll for off-screen

        return _dragging == toAccept && toAccept != toWrap.key;

      },
      onAccept: (Key accpeted) {},
      onLeave: (Object leaving) {},
    );
  }

}