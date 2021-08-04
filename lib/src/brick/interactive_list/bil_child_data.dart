import 'package:flutter/widgets.dart';

import 'package:ltogt_widgets/src/brick/interactive_list/bil_search_matches.dart';

class ChildDataBIL<T> {
  final T data;

  /// Build Function for the widget representing this [data].
  /// [data] is typically used in the implementation of [build]:
  ///
  /// [matches] will be non-null when the widget was found via search.
  /// The contained data can be used to build highlights or similar things.
  /// ```
  /// ChildData<MyObj>(
  ///   data: myObj,
  ///   build: (context, matches) => MyWidget(myObj: myObj, match: matches),
  /// ),
  /// ```
  final Widget Function(
    BuildContext context,
    StringOffsetByParameterName? matches,
  ) build;

  final ChildDataIdBIL id;

  ChildDataBIL({
    required this.data,
    required this.build,
  }) : id = ChildDataIdBIL.generate();
}

/// Auto-Generated ID for lookup to match [SearchMatchBIL] to [ChildDataBIL]
/// even when [BrickInteractiveList] changes the ordering and count of the child data.
class ChildDataIdBIL {
  final String value;
  const ChildDataIdBIL._(this.value);

  static int _circle = 0;
  static const int _circleMax = 1000;
  static ChildDataIdBIL generate() {
    ChildDataIdBIL._circle = _circle++ % _circleMax;
    return ChildDataIdBIL._(DateTime.now().toIso8601String() + "$_circle");
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChildDataIdBIL && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
