class ParameterBIL<T> {
  /// Unique Name of the parameter
  /// Need to use this to match the match results in [childData.build] to their parameters.
  final String name;

  /// -------------------------------------------------------------------------------- [Sorting]
  /// Ordering function
  final int Function(T d1, T d2)? sort;

  /// Annoyingly needed internally because of contravariance of parameters
  /// Make sure [sort] is not null before calling this method
  /// E.g. use [isSortDefined]
  int compareInternal<X>(X d1, X d2) => sort!.call(d1 as T, d2 as T);

  bool get isSortDefined => sort != null;

  /// -------------------------------------------------------------------------------- [Searching]
  /// If provided, the associated [ChildData] can be found via this [ParameterBIL]
  /// Must return the String representation of the parameter of [T]
  ///
  /// Any matches that are found will be passed to [childData.build].
  /// This can be used to highlight the matches in the children if so desired.
  final String Function(T value)? searchStringExtractor;

  /// Annoyingly needed internally because of contravariance of parameters.
  /// Make sure that [searchStringExtractor] is not null befor calling this method.
  /// E.g. use [isSearchDefined]
  String searchStringExtractorInternal<X>(X d) => searchStringExtractor!.call(d as T);

  bool get isSearchDefined => searchStringExtractor != null;

  const ParameterBIL({
    required this.name,
    required this.sort,
    this.searchStringExtractor,
  }) : assert(
          sort != null || searchStringExtractor != null,
          "Useless parameter",
        );
}

class ParameterConsistencyCheckerBIL {
  static bool checkNoDuplicateNames<T>(List<ParameterBIL<T>> params) {
    Map<String, ParameterBIL> duplicateMap = {};
    for (final p in params) {
      final duplicate = duplicateMap[p.name];
      if (duplicate != null) {
        assert(
          false,
          "Found duplicate named parameter: ${duplicate.name}. This is not allowed, since unique names are needed in childData.build to know which parameter matched in search.",
        );
        return false;
      }
      duplicateMap[p.name] = p;
    }
    return true;
  }
}
