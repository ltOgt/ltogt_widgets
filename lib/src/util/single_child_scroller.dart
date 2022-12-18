import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Mainly a bad workaround for SingleChildScrollView not beeing able to scroll horizontally with mousewheel + dragging not working on web
class SingleChildScroller extends StatefulWidget {
  const SingleChildScroller({
    Key? key,
    required this.child,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
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

  ///{@template scrollToEnd}
  /// Whether to scroll to the end of the [scrollDirection] (including [reverse]) at the start of this widgets life.
  /// E.g. `reverse=false`, `scrollToEnd=true` leads to the content starting left, but the viewport starting right.
  /// If the child does not fill the entire viewport, this means that empty space is on the right.
  /// If the child fills more than the viewport, this means that the start of child is scrolled out of the viewport.
  /// {@endtemplate}
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
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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

  double get _signForDrag => widget.reverse ? 1 : -1;
  double get _signForWheel => widget.reverse ? -1 : 1;

  void _addDelta(double delta) {
    double minExtend = _controller.position.minScrollExtent;
    double maxExtend = _controller.position.maxScrollExtent;

    double newPos = _controller.offset + delta;

    // dont overscroll
    if (newPos < minExtend) {
      newPos = minExtend;
    } else if (newPos > maxExtend) {
      newPos = maxExtend;
    }

    _controller.jumpTo(newPos);
  }

  void _updateScroll(PointerSignalEvent e) {
    if (e is PointerScrollEvent) {
      double deltaUsed;
      double deltaX = e.scrollDelta.dx;
      double deltaY = e.scrollDelta.dy;

      if (e.kind == PointerDeviceKind.mouse) {
        // Mouse-Wheel can only be scrolled on Y-Axis, regardless of scroll axis
        deltaUsed = _signForWheel * deltaY;
        // for some reason, trackpad is also mouse instead of touch
      } else {
        deltaUsed = isVertical ? deltaY : deltaX;
      }

      // eye-balled 1/3 of mouse scroll
      _addDelta(deltaUsed / 3);
    }
  }

  void _updateDrag(DragUpdateDetails d) {
    if (d.primaryDelta != null) {
      _addDelta(_signForDrag * d.primaryDelta!);
    }
  }

  bool get isHorizontal => widget.scrollDirection == Axis.horizontal;
  bool get isVertical => widget.scrollDirection == Axis.vertical;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (s) {
        if (s is PointerScrollEvent) {
          GestureBinding.instance.pointerSignalResolver.register(s, _updateScroll);
        }
      },
      child: GestureDetector(
        onVerticalDragUpdate: isVertical ? _updateDrag : null,
        onHorizontalDragUpdate: isHorizontal ? _updateDrag : null,
        child: SingleChildScrollView(
          primary: false,
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
