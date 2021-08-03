import 'package:flutter/widgets.dart';
import 'package:ltogt_utils/ltogt_utils.dart';

class ChildDataBIL<T> {
  final T data;

  /// Build Function for the widget representing this [data].
  /// [data] is typically used in the implementation of [build]:
  /// ```dart
  /// ChildData<MyObj>(
  ///   data: myObj,
  ///   build: (context) => MyWidget(e: e),
  /// ),
  /// ```
  final Widget Function(
    BuildContext context,
    /*StringOffset? searchMatch*/
  ) build;

  /// BIL needs to know which item matches to filter them by
  /// BIL provides the match offset to the widget (via build ?)
  /// ChildData provides the content that can be searched via an optional function
  //final String Function()? searchPoint;

  /// maybe do this via searchOptions after all
  /// that way you can have multiple parts of [data] exposed via different search options on T
  /// searchMatch would need to know which searchPoint was hit (maybe just via index on the search option list)
  ///
  ///
  ///
  /// build children via ChildData
  ///   includes builder that uses the rest of the object at declaration site
  ///     § ```dart
  ///       ChildData<MyObj>(
  ///         data: myObj,
  ///         build: (context) => MyWidget(e: e),
  ///       ),
  ///       ```
  ///   for all parameters of <MyObj>
  ///     make searchable
  ///       with buildMatch for hits on that parameter
  ///     make sortable
  ///       needs to define order on that parameter
  /// basically want:
  ///   List<DATA>
  ///

  const ChildDataBIL({
    required this.data,
    required this.build,
  });
}
