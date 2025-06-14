class StrapiQueryBuilder {
  final List<String> _filters = [];
  final List<String> _sorts = [];
  final List<String> _selects = [];
  final List<String> _populates = [];
  final List<String> _searches = [];
  int? _page;
  int? _pageSize;

  // Add search filter
  StrapiQueryBuilder search(String field, String value) {
    _searches.add('filters[$field][\$containsi]=${Uri.encodeComponent(value)}');
    return this;
  }

  // Add OR search filter
  StrapiQueryBuilder orSearch(String field, String value) {
    _searches.add(
      'filters[\$or][0][$field][\$containsi]=${Uri.encodeComponent(value)}',
    );
    return this;
  }

  // Add filter
  StrapiQueryBuilder filter(String field, dynamic value) {
    if (value is String) {
      _filters.add('filters[$field][\$eq]=${Uri.encodeComponent(value)}');
    } else {
      _filters.add('filters[$field][\$eq]=$value');
    }
    return this;
  }

  // Add OR filter
  StrapiQueryBuilder filterOr(String field, dynamic value) {
    final orIndex = _filters.where((f) => f.contains('\$or')).length;
    if (value is String) {
      _filters.add(
        'filters[\$or][$orIndex][$field][\$eq]=${Uri.encodeComponent(value)}',
      );
    } else {
      _filters.add('filters[\$or][$orIndex][$field][\$eq]=$value');
    }
    return this;
  }

  // Add not equal filter
  StrapiQueryBuilder filterNot(String field, dynamic value) {
    if (value is String) {
      _filters.add('filters[$field][\$ne]=${Uri.encodeComponent(value)}');
    } else {
      _filters.add('filters[$field][\$ne]=$value');
    }
    return this;
  }

  // Add contains filter
  StrapiQueryBuilder filterContains(String field, String value) {
    _filters.add('filters[$field][\$containsi]=${Uri.encodeComponent(value)}');
    return this;
  }

  // Add date range filter
  StrapiQueryBuilder filterDateRange(
    String field,
    DateTime? from,
    DateTime? to,
  ) {
    if (from != null) {
      _filters.add('filters[$field][\$gte]=${from.toIso8601String()}');
    }
    if (to != null) {
      _filters.add('filters[$field][\$lte]=${to.toIso8601String()}');
    }
    return this;
  }

  // Add sorting
  StrapiQueryBuilder sortBy(String field, {bool desc = false}) {
    _sorts.add('sort[0]=$field:${desc ? 'desc' : 'asc'}');
    return this;
  }

  // Add multiple sorting
  StrapiQueryBuilder sortByMultiple(Map<String, bool> sorts) {
    int index = _sorts.length;
    sorts.forEach((field, desc) {
      _sorts.add('sort[$index]=$field:${desc ? 'desc' : 'asc'}');
      index++;
    });
    return this;
  }

  // Add field selection
  StrapiQueryBuilder select(List<String> fields) {
    for (int i = 0; i < fields.length; i++) {
      _selects.add('fields[$i]=${fields[i]}');
    }
    return this;
  }

  // Add populate field
  StrapiQueryBuilder populateField(String field, {List<String>? fields}) {
    if (fields != null && fields.isNotEmpty) {
      for (int i = 0; i < fields.length; i++) {
        _populates.add('populate[$field][fields][$i]=${fields[i]}');
      }
    } else {
      _populates.add('populate=$field');
    }
    return this;
  }

  // Add nested populate
  StrapiQueryBuilder populateNested(
    String field,
    String nestedField, {
    List<String>? fields,
  }) {
    if (fields != null && fields.isNotEmpty) {
      for (int i = 0; i < fields.length; i++) {
        _populates.add(
          'populate[$field][populate][$nestedField][fields][$i]=${fields[i]}',
        );
      }
    } else {
      _populates.add('populate[$field][populate]=$nestedField');
    }
    return this;
  }

  // Add pagination
  StrapiQueryBuilder paginate(int page, int pageSize) {
    _page = page;
    _pageSize = pageSize;
    return this;
  }

  // Build the final query string
  String build() {
    final List<String> queryParts = [];

    // Add searches
    queryParts.addAll(_searches);

    // Add filters
    queryParts.addAll(_filters);

    // Add sorts
    queryParts.addAll(_sorts);

    // Add selects
    queryParts.addAll(_selects);

    // Add populates
    queryParts.addAll(_populates);

    // Add pagination
    if (_page != null && _pageSize != null) {
      queryParts.add('pagination[page]=$_page');
      queryParts.add('pagination[pageSize]=$_pageSize');
    }

    return queryParts.join('&');
  }

  // Reset builder for reuse
  void reset() {
    _filters.clear();
    _sorts.clear();
    _selects.clear();
    _populates.clear();
    _searches.clear();
    _page = null;
    _pageSize = null;
  }
}
