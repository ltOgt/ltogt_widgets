// ignore_for_file: non_constant_identifier_names

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

import 'package:ltogt_widgets/ltogt_widgets.dart';
import 'package:ltogt_widgets/src/brick/interactive_list/bil_child_data.dart';
import 'package:ltogt_widgets/src/brick/interactive_list/bil_parameter.dart';
import 'package:ltogt_widgets/src/brick/interactive_list/bil_search_matches.dart';
import 'package:ltogt_widgets/src/const/sizes.dart';
import 'package:ltogt_widgets/src/enum/brick_elevation.dart';
import 'package:ltogt_widgets/src/enum/sort_order.dart';
import 'package:ltogt_widgets/src/style/brick_theme_provider.dart';

class BrickInteractiveList<T> extends StatefulWidget {
  const BrickInteractiveList({
    Key? key,
    required this.childData,
    required this.childDataParameters,
    this.isSearchEnabled = false,
    this.isSortEnabled = false,
    this.topBarTrailing = const [],
    this.topBarTrailingClose = const [],
    this.topBarChildrenBelow,
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

  /// Whether search is enabled
  final bool isSearchEnabled;

  /// Whether sorting is enabled
  final bool isSortEnabled;

  /// Widgets to add to the bar at the end
  // TODO maybe remove this
  final List<Widget> topBarTrailing;

  /// Widgets to add to the bar, right after [childDataParameters]
  // TODO maybe remove this
  final List<Widget> topBarTrailingClose;

  /// Widget to add directly below sortBar
  // TODO maybe remove this
  final List<Widget>? topBarChildrenBelow;

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
  /// ============================================================== Child Data
  /// Contains a subset of [widget.childData] that may be
  /// - re-sorted based on parameter ordering
  /// - filtered based on parameter search
  late LinkedHashSet<ChildDataBIL<T>> sManipulatedChildren;

  // does not call setState
  void _resetManipulatedChildrenFromWidget() {
    sManipulatedChildren = LinkedHashSet.from(widget.childData);
  }

  // does not call set state
  void _clearManipulatedChildren() {
    sManipulatedChildren = LinkedHashSet();
  }

  /// ============================================================== Lifecyle-Functions

  @override
  void initState() {
    super.initState();

    _checkIfSearchEnabled();
    _checkIfSortEnabled();

    _resetManipulatedChildrenFromWidget();
    // intial ordering to sync list and sort key
    _order(sSortParam);
  }

  @override
  void didUpdateWidget(covariant BrickInteractiveList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// If childData has changed, reset subset and re-apply manipulations
    if (false == listEquals(oldWidget.childData, widget.childData)) {
      /// Reset
      _resetManipulatedChildrenFromWidget();

      // Re-Apply
      _applyFilterToChildData();
      _order(sSortParam);
    }

    /// If size of bar might have changed, recalculate child padding // TODO confirm list equals works as expected
    bool _barChildChanged = oldWidget.topBarChildrenBelow != widget.topBarChildrenBelow;
    bool _additionalPaddingChanged = oldWidget.additionalContentPadding != widget.additionalContentPadding;
    if (_barChildChanged || _additionalPaddingChanged) {
      calculateBarPaddingInNextFrame();
    }

    /// If [widget.isSearchEnabled] or [widget.childDataParameters] changed, re-check if search is active
    if (oldWidget.isSearchEnabled != widget.isSearchEnabled ||
        widget.childDataParameters != oldWidget.childDataParameters) {
      _checkIfSearchEnabled();
    }

    /// If [widget.isSortEnabled] or [widget.childDataParameters] changed, re-check if sort is active
    if (oldWidget.isSortEnabled != widget.isSortEnabled ||
        widget.childDataParameters != oldWidget.childDataParameters) {
      _checkIfSortEnabled();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    sTheme = BrickThemeProvider.getTheme(context);
  }

  /// ============================================================== SORTING
  late bool sIsSortEnabled;

  // does not call setState
  // check if parent enabled search and iff so if search is defined on params
  void _checkIfSortEnabled() {
    bool _existsParamThatDefinesSort =
        widget.childDataParameters.fold(false, (bool acc, ParameterBIL e) => acc || e.isSortDefined);

    sIsSortEnabled = widget.isSortEnabled && _existsParamThatDefinesSort;
    assert(
      false == sIsSortEnabled || _existsParamThatDefinesSort,
      "Sort enabled, but no sort defined via parameters",
    );
  }

  late ParameterBIL<T> sSortParam = widget.childDataParameters.first; // TODO handle empty list

  SortOrder sSortOrder = SortOrder.DECR;
  bool get isOrderDesc => sSortOrder == SortOrder.DECR;

  /// does not call setState, needs to be done by caller
  void _order(ParameterBIL<T> sortOption) {
    var _currentChildData = sManipulatedChildren.toList();
    _currentChildData.sort((ChildDataBIL<T> p1, ChildDataBIL<T> p2) => sortOption.compareInternal<T>(p1.data, p2.data));

    if (sSortOrder == SortOrder.INCR) {
      _currentChildData = _currentChildData.reversed.toList();
    }

    sManipulatedChildren = LinkedHashSet.from(_currentChildData);
  }

  void changeOrder(ParameterBIL<T> sortParam) {
    if (sortParam == sSortParam) {
      // invert ordering if sortParameter is already active
      sSortOrder = isOrderDesc ? SortOrder.INCR : SortOrder.DECR;
    } else {
      // switch to new sortParameter
      sSortParam = sortParam;
    }
    _order(sortParam);
    setState(() {});
  }

  /// ============================================================== SEARCHING
  late bool sIsSearchEnabled;

  /// Whether the search bar is visible or not
  bool sIsSearchBarVisible = false;

  /// Whether the search should be interpreted as regex
  /// Only effective when [sIsSearchBarVisible]search
  bool sIsSearchRegexMode = false;

  /// The actual String typed by the user
  String? sSearchInput;

  /// Collection of matches in [widget.childData] based on active [widget.childDataParameters]
  SearchMatchesBIL sSearchMatches = SearchMatchesBIL({}); // TODO needs to be reset

  // does not call setState
  // check if parent enabled search and iff so if search is defined on params
  void _checkIfSearchEnabled() {
    bool _existsParamThatDefinesSearch = widget.childDataParameters.fold(
      false,
      (acc, e) => acc || e.isSearchDefined,
    );

    sIsSearchEnabled = widget.isSearchEnabled && _existsParamThatDefinesSearch;
    assert(
      false == widget.isSearchEnabled || _existsParamThatDefinesSearch,
      "Search enabled, but no search defined via parameters",
    );

    if (false == sIsSearchEnabled) {
      sIsSearchBarVisible = false;
      sSearchMatches.matches.clear();
      sSearchInput = null;
    }
  }

  void onToggleSearchRegexMode() {
    setState(() {
      sIsSearchRegexMode = !sIsSearchRegexMode;
      // re-sort with new regex mode
      _applyFilterToChildData();
    });
  }

  /// does not call setState, needs to be done by caller
  void _resetChildDataSearchManipulation() {
    _resetManipulatedChildrenFromWidget();
    sSearchMatches.matches.clear();

    if (sIsSortEnabled) {
      _order(sSortParam);
    }
  }

  /// Hide or show the search bar and reset related state
  void onPressSearchIcon() {
    calculateBarPaddingInNextFrame();
    setState(
      () {
        sIsSearchBarVisible = !sIsSearchBarVisible;

        /// clear stored search
        sSearchInput = null;

        /// reset filtered list
        _resetChildDataSearchManipulation();
      },
    );
  }

  /// Update search string and filter list
  void onTypeSearch(String s) => setState(() {
        /// save typed string
        sSearchInput = s;

        _applyFilterToChildData();

        if (sIsSortEnabled) {
          _order(sSortParam);
        }
      });

  /// does not call setState, needs to be done by caller
  void _applyFilterToChildData() {
    if (false == StringHelper.isFilled(sSearchInput)) {
      _resetChildDataSearchManipulation();
      return;
    }

    // TODO change to StringOffset? with null acting as false
    StringOffset? Function(String searchable)? matchSearchable;

    if (sIsSearchRegexMode) {
      // Try catch for regex, since it might not be valid in the current state
      try {
        final regex = RegExp(sSearchInput!);
        matchSearchable = (String searchable) => StringOffset.fromRegexMatchOrNull(
              regex.firstMatch(searchable),
            );
      } on FormatException catch (_) {
        // matcher stays null -> dont apply anything
      }
    } else {
      matchSearchable = (String searchable) => StringOffset.fromSubstringMatchOrNull(
            StringHelper.matchSubstring(searchable, sSearchInput!),
          );
    }

    // If regex did not fail to compile, match children based on the active parameters
    // TODO keep track of all active parameters; maybe need mutli param for sorting as well; maybe need custom ordering of parameters to prioritize combinations
    if (matchSearchable != null) {
      // Clear to re-populate
      _clearManipulatedChildren();
      sSearchMatches.matches.clear();

      for (final param in widget.childDataParameters) {
        // only for parameters that define search string extractor
        if (false == param.isSearchDefined) {
          continue;
        }

        // shorthand for extractor + contravariance workaround
        searchableFrom(T t) => param.searchStringExtractorInternal<T>(t);

        // add matching childData
        for (final childDatum in widget.childData) {
          // get searchable data from parameter and use to search against
          StringOffset? match = matchSearchable(searchableFrom(childDatum.data));

          if (match != null) {
            // add to list that will be rendered
            sManipulatedChildren.add(childDatum);

            // store match to send to childData.build
            if (false == sSearchMatches.matches.containsKey(childDatum.id)) {
              sSearchMatches.matches[childDatum.id] = {};
            }
            sSearchMatches.matches[childDatum.id]![param.name] = match;
          }
        }
      }
    }
  }

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

  EdgeInsets _calculateContentPadding() {
    // : Add padding with same height as bar after first frame (for first frame approx. with 60)
    final _barPadding = (sBarPadding ?? 60.0) + 1;

    final basePadding = EdgeInsets.only(
      top: widget.isBarOnTop ? _barPadding : 0,
      bottom: widget.isBarOnTop ? 0 : _barPadding,
      right: 10,
      left: 10,
    );

    // : Add additional content padding if user of this widget puts additional elements on top of the list similar to the bar
    return EdgeInsets.only(
      top: basePadding.top + widget.additionalContentPadding.top,
      bottom: basePadding.bottom + widget.additionalContentPadding.bottom,
      right: basePadding.right + widget.additionalContentPadding.right,
      left: basePadding.left + widget.additionalContentPadding.left,
    );
  }

  /// ============================================================== theme
  late BrickTheme sTheme;

  /// ============================================================== widgets
  Widget buildSearchButton() => BrickIconButton(
        isActive: sIsSearchBarVisible,
        onPressed: (_) => onPressSearchIcon(),
        icon: Icon(Icons.search, color: sTheme.color.icon),
        size: SMALL_BUTTON_SIZE,
      );

  Widget buildSearchBar() => BendContainer(
        mode: BendMode.CONCAVE,
        showBorder: true,
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            BrickTextField(
              showLine: false,
              maxLines: 1,
              onChange: onTypeSearch,
              hint: "Filter",
              autofocus: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _RegexIndicator(
                isRegex: sIsSearchRegexMode,
                onPress: onToggleSearchRegexMode,
              ),
            )
          ],
        ),
      );

  /// ============================================================== assertions
  void assertions() {
    assert(ParameterConsistencyCheckerBIL.checkNoDuplicateNames(widget.childDataParameters));
  }

  /// ============================================================== build
  @override
  Widget build(BuildContext context) {
    assertions();

    if (sBarPadding == null) {
      calculateBarPaddingInNextFrame();
    }

    final theme = BrickThemeProvider.getTheme(context);

    // TODO might need to rework layout of bar and what is exposed
    var _topBarTrailing = [
      if (sIsSearchEnabled) buildSearchButton(),
      ...widget.topBarTrailing,
    ];

    // TODO might need to rework layout of bar and what is exposed
    List<Widget>? _topBarBelow = [
      if (sIsSearchBarVisible) buildSearchBar(),
      if (null != widget.topBarChildrenBelow) ...widget.topBarChildrenBelow!,
    ];
    if (_topBarBelow.isEmpty) _topBarBelow = null;

    final EdgeInsets _contentPadding = _calculateContentPadding();

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
              childPadding: _contentPadding,
              overlay: [
                /// ------------------------------------------------- [_OrderBar]
                Positioned(
                  top: widget.isBarOnTop ? 0 : null,
                  bottom: widget.isBarOnTop ? null : 0,
                  left: 0,
                  right: 0,
                  child: _InteractionBar<T>(
                    key: barKey,
                    isSortEnabled: sIsSortEnabled,
                    isOrderDesc: isOrderDesc,
                    activeSortOption: sSortParam,
                    sortOptions: widget.childDataParameters.where((p) => p.isSortDefined).toList(),
                    onChangeOrder: changeOrder,
                    onToggleDirection: () => changeOrder(sSortParam),
                    trailing: _topBarTrailing,
                    trailingClose: widget.topBarTrailingClose,
                    childrenBelow: _topBarBelow,
                  ),
                ),

                if (sSearchMatches.matches.isNotEmpty)
                  Positioned(
                    top: widget.isBarOnTop ? _contentPadding.top + 10 : null,
                    bottom: widget.isBarOnTop ? null : _contentPadding.bottom + 10,
                    right: 20,
                    child: Text("${sSearchMatches.matches.length}/${widget.childData.length}"),
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
                  list: sManipulatedChildren.toList(),
                  builder: (ChildDataBIL data, int i) {
                    return data.build(context, sSearchMatches.matches[data.id]);
                  },
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
class _InteractionBar<T> extends StatelessWidget {
  const _InteractionBar({
    Key? key,
    required this.onChangeOrder,
    required this.onToggleDirection,
    required this.isSortEnabled,
    required this.activeSortOption,
    required this.sortOptions,
    required this.isOrderDesc,
    required this.trailing,
    required this.trailingClose,
    this.childrenBelow,
  }) : super(key: key);

  final void Function(ParameterBIL<T> sortKey) onChangeOrder;
  final void Function() onToggleDirection;
  final ParameterBIL<T> activeSortOption;
  final List<ParameterBIL<T>> sortOptions;
  final bool isOrderDesc;
  final List<Widget> trailing;
  final List<Widget> trailingClose;
  final List<Widget>? childrenBelow;

  final bool isSortEnabled;

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
        condition: childrenBelow != null,
        parentBuilder: (child) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child,
            SIZED_BOX_10,
            ...childrenBelow!,
          ],
        ),
        child: BrickScrollStack(
          crossAxisSize: scrollAreaHeight,
          scrollDirection: Axis.horizontal,
          leading: Row(
            children: [
              if (isSortEnabled) ...[
                BrickIconButton(
                  size: SMALL_BUTTON_SIZE,
                  onPressed: (_) => onToggleDirection(),
                  icon: isOrderDesc ? _arrowDownIcon : _arrowUpIcon,
                ),
                SIZED_BOX_10,
              ],
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
            if (isSortEnabled)
              ...ListGenerator.seperated(
                seperator: SIZED_BOX_10,
                leadingSeperator: true,
                list: sortOptions,
                builder: (ParameterBIL<T> option, int i) {
                  return BrickButton(
                    child: Text(option.name),
                    isActive: activeSortOption == option,
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

class _RegexIndicator extends StatelessWidget {
  const _RegexIndicator({
    Key? key,
    required this.isRegex,
    required this.onPress,
  }) : super(key: key);

  final bool isRegex;
  final Function() onPress;

  static const _transparentRed = Color(0x55FF3333);

  @override
  Widget build(BuildContext context) {
    final color = isRegex ? _transparentRed : Colors.transparent;

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BORDER_RADIUS_ALL_5,
      ),
      child: BrickInkWell(
        color: color,
        onTap: (_) => onPress(),
        child: const Text(" .* "),
      ),
    );
  }
}
