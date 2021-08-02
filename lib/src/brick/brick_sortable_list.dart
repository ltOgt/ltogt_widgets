import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

import 'package:ltogt_widgets/ltogt_widgets.dart';
import 'package:ltogt_widgets/src/const/sizes.dart';
import 'package:ltogt_widgets/src/enum/brick_elevation.dart';
import 'package:ltogt_widgets/src/enum/sort_order.dart';
import 'package:ltogt_widgets/src/style/brick_theme_provider.dart';
import 'package:ltogt_widgets/src/util/single_child_scroller.dart';

class BrickSortableList<T> extends StatefulWidget {
  const BrickSortableList({
    Key? key,
    required this.childData,
    required this.sortingOptions,
    this.sortBarTrailing = const [],
    this.sortBarTrailingClose = const [],
    this.sortBarChildBelow,
    this.isBarOnTop = true,
    this.additionalContentPadding = EdgeInsets.zero,
    this.elevation = BrickElevation.RECESSED,
  }) : super(key: key);

  /// Items to be build and sorted
  final List<ChildData<T>> childData;

  /// Sorting Options to sort [childData] by
  final List<SortingOption<T>> sortingOptions;

  /// Widgets to add to the bar at the end
  final List<Widget> sortBarTrailing;

  /// Widgets to add to the bar, right after [sortingOptions]
  final List<Widget> sortBarTrailingClose;

  /// Widget to add directly below sortBar
  final Widget? sortBarChildBelow;

  /// If true, the bar is rendered at the start of the list.
  /// Otherwise it is rendered at the bottom
  final bool isBarOnTop;

  /// Additional content padding.
  /// Useful e.g. if you want to overlay additional widgets and push the items accordingly
  final EdgeInsets additionalContentPadding;

  /// Elevation of the widget in relation to the parent widget.
  ///
  /// Defaults to [BrickElevation.RECESSED]
  final BrickElevation elevation;

  @override
  State<BrickSortableList> createState() => _BrickSortableListState();
}

class _BrickSortableListState<T> extends State<BrickSortableList<T>> {
  /// ============================================================== State
  late SortingOption<T> __sortOption = widget.sortingOptions.first; // TODO handle empty list

  SortOrder __sortOrder = SortOrder.DECR;
  bool get isOrderDesc => __sortOrder == SortOrder.DECR;

  late List<ChildData<T>> __sortedChildren = widget.childData;

  /// ============================================================== Lifecyle-Functions

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

  /// ============================================================== State-Functions

  void _order(SortingOption<T> sortOption) {
    __sortedChildren.sort((ChildData<T> p1, ChildData<T> p2) => sortOption._compare<T>(p1.data, p2.data));

    if (__sortOrder == SortOrder.INCR) {
      __sortedChildren = __sortedChildren.reversed.toList();
    }
  }

  void changeOrder(SortingOption<T> sortOption) {
    if (sortOption == __sortOption) {
      __sortOrder = isOrderDesc ? SortOrder.INCR : SortOrder.DECR;
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

  EdgeInsetsGeometry _calculateContentPadding() {
    // : Add padding with same height as bar after first frame (for first frame approx. with 60)
    final _barPadding = (barPadding ?? 60.0) + 1;

    final basePadding = EdgeInsets.only(
      top: widget.isBarOnTop ? _barPadding : 0,
      bottom: widget.isBarOnTop ? 0 : _barPadding,
      right: 10,
      left: 10,
    );

    // : Add additional content padding if user of this widget puts additional elements on top of the list similar to the bar
    return basePadding.add(widget.additionalContentPadding);
  }

  /// ============================================================== build
  @override
  Widget build(BuildContext context) {
    if (barPadding == null) {
      calculateBarPaddingInNextFrame();
    }

    final theme = BrickThemeProvider.getTheme(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: theme.radius.medium,
        color: theme.color.background2,
        boxShadow: widget.elevation.isElevated ? theme.shadow.elevated : null,
      ),
      child: ClipRRect(
        borderRadius: theme.radius.medium,
        child: Stack(
          children: [
            BrickScrollStack(
              scrollDirection: Axis.vertical,
              leadingShadow: [
                BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                  color: theme.color.shadow,
                )
              ],
              trailingShadow: [
                BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                  color: theme.color.shadow,
                )
              ],
              leadingCrossShadow: [
                BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(-1, 0),
                  color: theme.color.shadow,
                )
              ],
              trailingCrossShadow: [
                BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(1, 0),
                  color: theme.color.shadow,
                )
              ],
              childPadding: _calculateContentPadding(),
              children: [
                SIZED_BOX_5,
                // . not using leading/trailing since different sizes
                ...ListGenerator.seperated(
                  seperator: SIZED_BOX_2,
                  list: __sortedChildren,
                  builder: (ChildData data, int i) => data.build(context),
                ),
                SIZED_BOX_5,
              ],
            ),
            Positioned(
              top: widget.isBarOnTop ? 0 : null,
              bottom: widget.isBarOnTop ? null : 0,
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

//
//
//
//
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

  final double scrollAreaHeight = 32;

  @override
  Widget build(BuildContext context) {
    final theme = BrickThemeProvider.getTheme(context);

    final _arrowDownIcon = Icon(Icons.arrow_downward, color: theme.color.icon);
    final _arrowUpIcon = Icon(Icons.arrow_upward, color: theme.color.icon);

    return Container(
      decoration: BoxDecoration(
        color: theme.color.background2,
        borderRadius: theme.radius.medium,
        border: Border.all(color: theme.color.borderDark),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            spreadRadius: 2,
            color: theme.color.shadow,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: PADDING_ALL_10,
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
        child: BrickScrollStack(
          crossAxisSize: scrollAreaHeight,
          scrollDirection: Axis.horizontal,
          leading: Row(
            children: [
              BrickIconButton(
                size: SMALL_BUTTON_SIZE,
                onPressed: (_) => onToggleDirection(),
                icon: isOrderDesc ? _arrowDownIcon : _arrowUpIcon,
              ),
              SIZED_BOX_10,
              Container(
                height: scrollAreaHeight,
                width: 1,
                color: theme.color.borderLight,
              ),
            ],
          ),
          trailing: trailing.isEmpty
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: scrollAreaHeight,
                      width: 1,
                      color: theme.color.borderLight,
                    ),
                    SIZED_BOX_10,
                    ...WidgetListGenerator.spaced(
                      uniform: 5,
                      widgets: trailing,
                    ),
                  ],
                ),
          leadingShadow: [
            BoxShadow(
              blurRadius: 4,
              spreadRadius: 2,
              color: theme.color.shadow,
              offset: const Offset(-2, 0),
            ),
          ],
          trailingShadow: [
            BoxShadow(
              blurRadius: 4,
              spreadRadius: 2,
              color: theme.color.shadow,
              offset: const Offset(2, 0),
            ),
          ],
          children: [
            ...ListGenerator.seperated(
              seperator: SIZED_BOX_10,
              leadingSeperator: true,
              list: sortOptions,
              builder: (SortingOption<T> option, int i) {
                return BrickButton(
                  child: Text(option.name),
                  isActive: sortOption == option,
                  onPress: () => onChangeOrder(
                    option,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                );
              },
            ),
            ...WidgetListGenerator.spaced(
              uniform: 5,
              beforeFirst: true,
              widgets: trailingClose,
            ),
          ],
        ),
      ),
    );

    SingleChildScroller(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BrickIconButton(
            size: SMALL_BUTTON_SIZE,
            onPressed: (_) => onToggleDirection(),
            icon: isOrderDesc ? _arrowDownIcon : _arrowUpIcon,
          ),
          ...ListGenerator.seperated(
            seperator: SIZED_BOX_10,
            leadingSeperator: true,
            list: sortOptions,
            builder: (SortingOption<T> option, int i) {
              return BrickButton(
                child: Text(option.name),
                isActive: sortOption == option,
                onPress: () => onChangeOrder(
                  option,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
    );
  }
}

//
//
//
//
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

//
//
//
//
class ChildData<T> {
  final T data;
  final Widget Function(BuildContext context) build;

  const ChildData({
    required this.data,
    required this.build,
  });
}
