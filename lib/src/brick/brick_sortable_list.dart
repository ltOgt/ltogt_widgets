import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

import 'package:ltogt_widgets/ltogt_widgets.dart';

class SortingOption<T> {
  /// Name of the sorting option
  final String name;

  /// Ordering function
  final int Function(T e1, T e2) compare;

  /// Annoyingly needed internally because of contravariance of parameters
  int _compare<X>(X e1, X e2) => compare(e1 as T, e2 as T);

  const SortingOption({
    required this.name,
    required this.compare,
  });
}

class ChildData<T> {
  final T data;
  final Widget Function(BuildContext context) build;

  const ChildData({
    required this.data,
    required this.build,
  });
}

class BrickSortableList<T> extends StatefulWidget {
  static const defaultBoxConstraints = BoxConstraints(maxHeight: 400, maxWidth: 600, minHeight: 200);

  const BrickSortableList({
    Key? key,
    required this.childData,
    required this.sortingOptions,
    this.boxConstraints = defaultBoxConstraints,
    this.sortBarTrailing = const [],
    this.sortBarTrailingClose = const [],
    this.sortBarChildBelow,
    this.barOnTop = true,
    this.contentPadding = EdgeInsets.zero,
  }) : super(key: key);

  /// Items to be build and sorted
  final List<ChildData<T>> childData;

  /// Sorting Options to sort [childData] by
  final List<SortingOption<T>> sortingOptions;

  /// Contstraints for the whole widget
  final BoxConstraints boxConstraints;

  /// Widgets to add to the bar at the end
  final List<Widget> sortBarTrailing;

  /// Widgets to add to the bar, right after [sortingOptions]
  final List<Widget> sortBarTrailingClose;

  /// Widget to add directly below sortBar
  final Widget? sortBarChildBelow;

  /// If true, the bar is rendered at the start of the list.
  /// Otherwise it is rendered at the bottom
  final bool barOnTop;

  /// Additional content padding.
  /// Useful e.g. if you want to overlay additional widgets and push the items accordingly
  final EdgeInsets contentPadding;

  @override
  State<BrickSortableList> createState() => _BrickSortableListState();
}

enum _SortOrder {
  INCR,
  DECR,
}

class _BrickSortableListState<T> extends State<BrickSortableList<T>> {
  late SortingOption<T> __sortOption = widget.sortingOptions.first; // TODO handle empty list
  _SortOrder __sortOrder = _SortOrder.DECR;
  bool get isOrderDesc => __sortOrder == _SortOrder.DECR;

  late List<ChildData<T>> __sortedChildren = widget.childData;

  @override
  void initState() {
    super.initState();
    // intial ordering to sync list and sort key
    _order(__sortOption);
  }

  @override
  void didUpdateWidget(covariant BrickSortableList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (false == listEquals(oldWidget.childData, widget.childData)) {
      __sortedChildren = widget.childData;
      _order(__sortOption);
    }
    if (oldWidget.sortBarChildBelow != widget.sortBarChildBelow) {
      calculateBarPaddingInNextFrame();
    }
  }

  void _order(SortingOption<T> sortOption) {
    __sortedChildren.sort((ChildData<T> p1, ChildData<T> p2) => sortOption._compare<T>(p1.data, p2.data));

    if (__sortOrder == _SortOrder.INCR) {
      __sortedChildren = __sortedChildren.reversed.toList();
    }
  }

  void changeOrder(SortingOption<T> sortOption) {
    if (sortOption == __sortOption) {
      __sortOrder = isOrderDesc ? _SortOrder.INCR : _SortOrder.DECR;
      __sortedChildren = __sortedChildren.reversed.toList();
    } else {
      _order(sortOption);
    }

    // . also triggers update of __projects and __sortOrder
    setState(() {
      __sortOption = sortOption;
    });
  }

  final GlobalKey barKey = GlobalKey();

  double? barPadding;
  // Need to wait one frame for the bar to be sized
  void calculateBarPaddingInNextFrame() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        barPadding = RenderHelper.getSize(globalKey: barKey)?.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (barPadding == null) {
      calculateBarPaddingInNextFrame();
    }

    return ClipRRect(
      borderRadius: BORDER_RADIUS_ALL_10,
      child: Container(
        decoration: const BoxDecoration(
          color: BrickColors.GREY_2,
        ),
        constraints: widget.boxConstraints,
        //margin: PADDING_HORIZONTAL_40,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: widget.barOnTop ? (barPadding ?? 60.0) + 1 : 0,
                right: 10,
                left: 10,
                bottom: widget.barOnTop ? 0 : (barPadding ?? 60.0) + 1,
              ).add(widget.contentPadding),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SIZED_BOX_5,
                    ...ListGenerator.seperated(
                      seperator: const SizedBox(
                        width: 2,
                        height: 2,
                      ),
                      list: __sortedChildren,
                      builder: (ChildData data, int i) => data.build(context),
                    ),
                    SIZED_BOX_5,
                  ],
                ),
              ),
            ),

            /// Shadow
            ...[
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 0,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, -2),
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 0,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                top: 0,
                left: 0,
                child: Container(
                  width: 0,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(-2, 0),
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                top: 0,
                right: 0,
                child: Container(
                  width: 0,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(2, 0),
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            // Bar
            Positioned(
              top: widget.barOnTop ? 0 : null,
              bottom: widget.barOnTop ? null : 0,
              left: 0,
              right: 0,
              child: _OrderBar<T>(
                key: barKey,
                isOrderDesc: isOrderDesc,
                sortOption: __sortOption,
                sortOptions: widget.sortingOptions,
                onChangeOrder: changeOrder,
                onToggleDirection: () => changeOrder(__sortOption),
                trailing: widget.sortBarTrailing,
                trailingClose: widget.sortBarTrailingClose,
                childBelow: widget.sortBarChildBelow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderBar<T> extends StatelessWidget {
  const _OrderBar({
    Key? key,
    required this.onChangeOrder,
    required this.onToggleDirection,
    required this.sortOption,
    required this.sortOptions,
    required this.isOrderDesc,
    required this.trailing,
    required this.trailingClose,
    this.childBelow,
  }) : super(key: key);

  final void Function(SortingOption<T> sortKey) onChangeOrder;
  final void Function() onToggleDirection;
  final SortingOption<T> sortOption;
  final List<SortingOption<T>> sortOptions;
  final bool isOrderDesc;
  final List<Widget> trailing;
  final List<Widget> trailingClose;
  final Widget? childBelow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BrickColors.GREY_2,
        borderRadius: BORDER_RADIUS_ALL_10,
        border: Border.all(color: Colors.black),
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: -2,
            color: Colors.black,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: PADDING_ALL_10,
      // TODO-? add SingleChildScroller
      child: ConditionalParentWidget(
        condition: childBelow != null,
        parentBuilder: (child) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child,
            SIZED_BOX_10,
            childBelow!,
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BrickIconButton(
              size: 30,
              onPressed: (_) => onToggleDirection(),
              icon: isOrderDesc ? const Icon(Icons.arrow_downward) : const Icon(Icons.arrow_upward),
            ),
            ...ListGenerator.seperated(
              seperator: SIZED_BOX_10,
              leadingSeperator: true,
              list: sortOptions,
              builder: (SortingOption<T> option, int i) {
                return BrickButton(
                  mode: (sortOption == option) ? BendMode.CONCAVE : BendMode.CONVEX,
                  bgColor: (sortOption == option) ? BrickColors.buttonActive : BrickColors.buttonIdle,
                  onPress: () => onChangeOrder(
                    option,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Text(option.name),
                );
              },
            ),
            ...WidgetListGenerator.spaced(
              uniform: 5,
              beforeFirst: true,
              widgets: trailingClose,
            ),
            const Expanded(child: SizedBox()),
            ...WidgetListGenerator.spaced(
              uniform: 5,
              widgets: trailing,
            ),
          ],
        ),
      ),
    );
  }
}
