// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

import 'package:ltogt_widgets/ltogt_widgets.dart';
import 'package:ltogt_widgets/src/brick/interactive_list/bil_child_data.dart';
import 'package:ltogt_widgets/src/brick/interactive_list/bil_parameter.dart';
import 'package:ltogt_widgets/src/const/sizes.dart';
import 'package:ltogt_widgets/src/enum/brick_elevation.dart';
import 'package:ltogt_widgets/src/enum/sort_order.dart';
import 'package:ltogt_widgets/src/style/brick_theme_provider.dart';
import 'package:ltogt_widgets/src/util/single_child_scroller.dart';

class BrickInteractiveList<T> extends StatefulWidget {
  const BrickInteractiveList({
    Key? key,
    required this.childData,
    required this.childDataParameters,
    this.topBarTrailing = const [],
    this.topBarTrailingClose = const [],
    this.topBarChildBelow,
    this.isBarOnTop = true,
    this.additionalContentPadding = EdgeInsets.zero,
    this.elevation = BrickElevation.RECESSED,
    this.overlay = const [],
  }) : super(key: key);

  /// Items to be build and sorted
  final List<ChildDataBIL<T>> childData;

  /// Accessors for each parameter of [T] that should be
  /// - searchable
  /// - sortable
  final List<ParameterBIL<T>> childDataParameters;

  /// Widgets to add to the bar at the end
  // TODO maybe remove this
  final List<Widget> topBarTrailing;

  /// Widgets to add to the bar, right after [childDataParameters]
  // TODO maybe remove this
  final List<Widget> topBarTrailingClose;

  /// Widget to add directly below sortBar
  // TODO maybe remove this
  final Widget? topBarChildBelow;

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

  /// List of children that are placed on top of the list and bar in a stack.
  /// Passed to [BrickScrollStack]
  final List<Widget> overlay;

  @override
  State<BrickInteractiveList> createState() => _BrickInteractiveListState();
}

class _BrickInteractiveListState<T> extends State<BrickInteractiveList<T>> {
  /// Contains a subset of [widget.childData] that may be
  /// - re-sorted based on parameter ordering
  /// - filtered based on parameter search
  late List<ChildDataBIL<T>> sManipulatedChildren = widget.childData;

  /// ============================================================== Lifecyle-Functions

  @override
  void initState() {
    super.initState();
    // intial ordering to sync list and sort key
    _order(sSortOption);
  }

  @override
  void didUpdateWidget(covariant BrickInteractiveList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// If childData has changed, reset subset and re-apply manipulations
    if (false == listEquals(oldWidget.childData, widget.childData)) {
      /// Reset
      sManipulatedChildren = widget.childData;

      // Re-Apply
      _order(sSortOption);
    }

    /// If size of bar might have changed, recalculate child padding
    bool _barChildChanged = oldWidget.topBarChildBelow != widget.topBarChildBelow;
    bool _additionalPaddingChanged = oldWidget.additionalContentPadding != widget.additionalContentPadding;
    if (_barChildChanged || _additionalPaddingChanged) {
      calculateBarPaddingInNextFrame();
    }
  }

  /// ============================================================== SORTING
  late ParameterBIL<T> sSortOption = widget.childDataParameters.first; // TODO handle empty list

  SortOrder sSortOrder = SortOrder.DECR;
  bool get isOrderDesc => sSortOrder == SortOrder.DECR;

  void _order(ParameterBIL<T> sortOption) {
    sManipulatedChildren
        .sort((ChildDataBIL<T> p1, ChildDataBIL<T> p2) => sortOption.compareInternal<T>(p1.data, p2.data));

    if (sSortOrder == SortOrder.INCR) {
      sManipulatedChildren = sManipulatedChildren.reversed.toList();
    }
  }

  void changeOrder(ParameterBIL<T> sortOption) {
    if (sortOption == sSortOption) {
      sSortOrder = isOrderDesc ? SortOrder.INCR : SortOrder.DECR;
      sManipulatedChildren = sManipulatedChildren.reversed.toList();
    } else {
      _order(sortOption);
    }

    // . also triggers update of __projects and __sortOrder
    setState(() {
      sSortOption = sortOption;
    });
  }

  /// ============================================================== SEARCHING

  /// ============================================================== SIZING
  final GlobalKey barKey = GlobalKey();
  double? sBarPadding;

  // Need to wait one frame for the bar to be sized
  void calculateBarPaddingInNextFrame() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        sBarPadding = RenderHelper.getSize(globalKey: barKey)?.height;
      });
    });
  }

  EdgeInsetsGeometry _calculateContentPadding() {
    // : Add padding with same height as bar after first frame (for first frame approx. with 60)
    final _barPadding = (sBarPadding ?? 60.0) + 1;

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
    if (sBarPadding == null) {
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

              /// ------------------------------------------------- [padding] for overlay
              childPadding: _calculateContentPadding(),
              overlay: [
                /// ------------------------------------------------- [_OrderBar]
                Positioned(
                  top: widget.isBarOnTop ? 0 : null,
                  bottom: widget.isBarOnTop ? null : 0,
                  left: 0,
                  right: 0,
                  child: _TopBar<T>(
                    key: barKey,
                    isOrderDesc: isOrderDesc,
                    sortOption: sSortOption,
                    sortOptions: widget.childDataParameters,
                    onChangeOrder: changeOrder,
                    onToggleDirection: () => changeOrder(sSortOption),
                    trailing: widget.topBarTrailing,
                    trailingClose: widget.topBarTrailingClose,
                    childBelow: widget.topBarChildBelow,
                  ),
                ),

                /// ------------------------------------------------- [overlay]
                ...widget.overlay,
              ],

              /// ------------------------------------------------- [children] sorted
              children: [
                SIZED_BOX_5,
                // . not using leading/trailing since different sizes
                ...ListGenerator.seperated(
                  seperator: SIZED_BOX_2,
                  list: sManipulatedChildren,
                  builder: (ChildDataBIL data, int i) => data.build(context),
                ),
                SIZED_BOX_5,
              ],

              /// ------------------------------------------------- [shadows]
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
class _TopBar<T> extends StatelessWidget {
  const _TopBar({
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

  final void Function(ParameterBIL<T> sortKey) onChangeOrder;
  final void Function() onToggleDirection;
  final ParameterBIL<T> sortOption;
  final List<ParameterBIL<T>> sortOptions;
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
              builder: (ParameterBIL<T> option, int i) {
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
  }
}
