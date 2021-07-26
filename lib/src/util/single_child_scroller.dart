import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SingleChildScroller extends StatefulWidget {
  const SingleChildScroller({
    Key? key,
    required this.child,
    required this.scrollDirection,
    required this.reverse,
    this.scrollToEnd = false,
  }) : super(key: key);

  /// Single child to scroll, usually [Row] or [Column]
  final Widget child;

  /// The axis on which should be scrolled.
  /// Usually [Axis.horizontal] for [Row] and [Axis.vertical] for [Column].
  final Axis scrollDirection;

  /// Whether to anchor the content at the end of the reading direction.
  /// E.g. start right when reading direction is left-to-right
  final bool reverse;

  /// Whether to scroll to the end of the [scrollDirection] (including [reverse]) at the start of this widgets life.
  /// E.g. `reverse=false`, `scrollToEnd=true` leads to the content starting left, but the viewport starting right.
  /// If the child does not fill the entire viewport, this means that empty space is on the right.
  /// If the child fills more than the viewport, this means that the start of child is scrolled out of the viewport.
  final bool scrollToEnd;

  @override
  _SingleChildScrollerState createState() => _SingleChildScrollerState();
}

class _SingleChildScrollerState extends State<SingleChildScroller> {
  late ScrollController _controller;
  void rebuild() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(rebuild);
    if (widget.scrollToEnd) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(rebuild);
    _controller.dispose();
    super.dispose();
  }

  void _addDelta(double delta) {
    _controller.jumpTo(_controller.offset + _sign * delta);
  }

  void _updateDrag(DragUpdateDetails d) {
    if (d.primaryDelta != null) {
      _addDelta(d.primaryDelta!);
    }
  }

  int get _sign => widget.reverse ? 1 : -1;

  bool get isHorizontal => widget.scrollDirection == Axis.horizontal;
  bool get isVertical => widget.scrollDirection == Axis.vertical;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (s) {
        if (s is PointerScrollEvent) {
          // eye-balled 1/3 of mouse scroll
          _addDelta(s.scrollDelta.dy / 3);
        }
      },
      child: GestureDetector(
        onVerticalDragUpdate: isVertical ? _updateDrag : null,
        onHorizontalDragUpdate: isHorizontal ? _updateDrag : null,
        child: SingleChildScrollView(
          // TODO expose if ever needed
          controller: _controller,
          scrollDirection: widget.scrollDirection,
          reverse: widget.reverse,
          child: widget.child,
        ),
      ),
    );
  }
}
