class StrapiQueryBuilder {
  final List<String> _filters = [];
  final List<String> _orFilters = [];
  final List<String> _sorts = [];
  final List<String> _selects = [];
  final List<String> _populates = [];
  int? _page;
  int? _pageSize;

  // Basic equals filter
  StrapiQueryBuilder filter(String field, dynamic value) {
    final val = value is String ? Uri.encodeComponent(value) : value;
    final encodedField = field.replaceAll('.', ']['); // ganti dot jadi bracket
    _filters.add('filters[$encodedField][\$eq]=$val');
    return this;
  }

  // Not equal filter
  StrapiQueryBuilder filterNot(String field, dynamic value) {
    final val = value is String ? Uri.encodeComponent(value) : value;
    _filters.add('filters[$field][\$ne]=$val');
    return this;
  }

  // Contains insensitive
  StrapiQueryBuilder filterContains(String field, String value) {
    _filters.add('filters[$field][\$containsi]=${Uri.encodeComponent(value)}');
    return this;
  }

  // Date range filter
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

  // OR: Contains insensitive
  StrapiQueryBuilder orContains(String field, String value) {
    final index = _orFilters.length;
    _orFilters.add(
      'filters[\$or][$index][$field][\$containsi]=${Uri.encodeComponent(value)}',
    );
    return this;
  }

  // OR: Equals
  StrapiQueryBuilder orEq(String field, dynamic value) {
    final index = _orFilters.length;
    final val = value is String ? Uri.encodeComponent(value) : value;
    _orFilters.add('filters[\$or][$index][$field][\$eq]=$val');
    return this;
  }

  // Sorting
  StrapiQueryBuilder sortBy(String field, {bool desc = false}) {
    _sorts.add('sort[${_sorts.length}]=$field:${desc ? 'desc' : 'asc'}');
    return this;
  }

  // Multiple sort
  StrapiQueryBuilder sortByMultiple(Map<String, bool> sorts) {
    sorts.forEach((field, desc) {
      _sorts.add('sort[${_sorts.length}]=$field:${desc ? 'desc' : 'asc'}');
    });
    return this;
  }

  // Select fields
  StrapiQueryBuilder select(List<String> fields) {
    for (int i = 0; i < fields.length; i++) {
      _selects.add('fields[$i]=${fields[i]}');
    }
    return this;
  }

  // Populate single or multiple fields
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

  // Nested populate
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

  // Pagination
  StrapiQueryBuilder paginate(int page, int pageSize) {
    _page = page;
    _pageSize = pageSize;
    return this;
  }

  // Build final query
  String build() {
    final List<String> queryParts = [];
    queryParts.addAll(_filters);
    queryParts.addAll(_orFilters);
    queryParts.addAll(_sorts);
    queryParts.addAll(_selects);
    queryParts.addAll(_populates);
    if (_page != null && _pageSize != null) {
      queryParts.add('pagination[page]=$_page');
      queryParts.add('pagination[pageSize]=$_pageSize');
    }
    return queryParts.join('&');
  }

  // Reset builder
  void reset() {
    _filters.clear();
    _orFilters.clear();
    _sorts.clear();
    _selects.clear();
    _populates.clear();
    _page = null;
    _pageSize = null;
  }
}
