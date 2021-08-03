import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_widgets/src/brick/interactive_list/bil_child_data.dart';

import 'package:ltogt_widgets/src/brick/interactive_list/brick_interactive_list.dart';

/// Collection of all matches that occured while searching in [BrickInteractiveList]
///  with all active [ParameterBIL] ([BrickInteractiveList.childDataParameters])
///  on [BrickInteractiveList.childData].
///
/// Passed to [ChildDataBIL.build].
class SearchMatchesBIL {
  /// List of Matches for a child from [BrickInteractiveList.childData], identified by its auto-generated id.
  final Map<ChildDataIdBIL, List<SearchMatchBIL>> matches;

  SearchMatchesBIL(this.matches);
}

class SearchMatchBIL {
  /// The index of [BrickInteractiveList.childDataParameter] that matched
  final int parameterIndex;

  /// The name of  [BrickInteractiveList.childDataParameter] that matched
  final String parameterName;

  /// The range of a specific [ParameterBIL<T>] of [T] of [ChildDataBIL<T>] that was matched.
  final StringOffset matchOffset;

  SearchMatchBIL({
    required this.parameterIndex,
    required this.parameterName,
    required this.matchOffset,
  });
}
