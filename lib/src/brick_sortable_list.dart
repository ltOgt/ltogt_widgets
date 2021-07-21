import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:ltogt_utils/ltogt_utils.dart';

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
  const BrickSortableList({
    Key? key,
    required this.childData,
    required this.sortingOptions,
  }) : super(key: key);

  final List<ChildData<T>> childData;
  final List<SortingOption<T>> sortingOptions;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: BrickColors.GREY_2,
        borderRadius: BORDER_RADIUS_ALL_10,
      ),
      constraints: const BoxConstraints(maxHeight: 400, maxWidth: 600, minHeight: 0),
      margin: PADDING_HORIZONTAL_40,
      child: Column(
        children: [
          _OrderBar<T>(
            isOrderDesc: isOrderDesc,
            sortOption: __sortOption,
            sortOptions: widget.sortingOptions,
            onChangeOrder: changeOrder,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: ListGenerator.seperated(
                  seperator: const SizedBox(
                    width: 2,
                    height: 2,
                  ),
                  list: __sortedChildren,
                  builder: (ChildData data, int i) => data.build(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderBar<T> extends StatelessWidget {
  const _OrderBar({
    Key? key,
    required this.onChangeOrder,
    required this.sortOption,
    required this.sortOptions,
    required this.isOrderDesc,
  }) : super(key: key);

  final void Function(SortingOption<T> sortKey) onChangeOrder;
  final SortingOption<T> sortOption;
  final List<SortingOption<T>> sortOptions;
  final bool isOrderDesc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: BrickColors.GREY_2,
        borderRadius: BORDER_RADIUS_ALL_10,
      ),
      padding: PADDING_ALL_10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: ListGenerator.seperated(
          seperator: SIZED_BOX_5,
          list: sortOptions,
          builder: (SortingOption<T> option, int i) {
            return Container(
              padding: PADDING_ALL_5,
              decoration: const BoxDecoration(
                color: BrickColors.GREY_4,
                borderRadius: BORDER_RADIUS_ALL_10,
              ),
              child: InkWell(
                onTap: () => onChangeOrder(option),
                child: Row(
                  children: [
                    if (sortOption == option)
                      isOrderDesc ? const Icon(Icons.expand_more) : const Icon(Icons.expand_less),
                    Text(option.name),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
