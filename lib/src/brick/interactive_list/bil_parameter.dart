class ParameterBIL<T> {
  /// Name of the parameter
  /// Need to use this to match the match results in [childData.build] to their parameters.
  // TODO add consitency checker that names of all passed parameters are unique (via assert)
  final String name;

  /// -------------------------------------------------------------------------------- [Sorting]
  /// Ordering function
  // TODO make optional if parameter should not be sorted
  final int Function(T d1, T d2) sort;

  /// Annoyingly needed internally because of contravariance of parameters
  /// Make sure [sort] is not null before calling this method
  int compareInternal<X>(X d1, X d2) => sort(d1 as T, d2 as T);

  /// -------------------------------------------------------------------------------- [Searching]
  /// If provided, the associated [ChildData] can be found via this [ParameterBIL]
  /// Must return the String representation of the parameter of [T]
  ///
  /// Any matches that are found will be passed to [childData.build].
  /// This can be used to highlight the matches in the children if so desired.
  final String Function(T value)? searchStringExtractor;

  /// Annoyingly needed internally because of contravariance of parameters.
  /// Make sure that [searchStringExtractor] is not null befor calling this method.
  String? searchStringExtractorInternal<X>(X d) => searchStringExtractor!.call(d as T);

  const ParameterBIL({
    required this.name,
    required this.sort,
    this.searchStringExtractor,
  });
}
