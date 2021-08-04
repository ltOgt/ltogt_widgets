import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_widgets/src/brick/interactive_list/bil_child_data.dart';

import 'package:ltogt_widgets/src/brick/interactive_list/brick_interactive_list.dart';

/// Collection of all matches that occured while searching in [BrickInteractiveList]
///  with all active [ParameterBIL] ([BrickInteractiveList.childDataParameters])
///  on [BrickInteractiveList.childData].
///
/// Passed to [ChildDataBIL.build].
class SearchMatchesBIL {
  /// Map of Matches for a child from [BrickInteractiveList.childData], identified by its auto-generated id.
  final MatchesByChildId matches;

  SearchMatchesBIL(this.matches);
}

typedef MatchesByChildId = Map<ChildDataIdBIL, StringOffsetByParameterName>;
typedef StringOffsetByParameterName = Map<ParameterName, StringOffset>;
typedef ParameterName = String;
