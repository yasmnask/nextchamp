import 'package:flutter/foundation.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';

class CourseProvider extends ChangeNotifier {
  final CourseService _courseService = CourseService();

  List<Course> _courses = [];
  List<Course> _searchResults = [];
  Course? _selectedCourse;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isSearching = false;
  String? _error;
  Map<String, dynamic>? _meta;

  // Pagination state
  int _currentPage = 1;
  bool _hasMoreData = true;

  // Filter state
  String? _currentSearchTerm;
  String? _currentSortField;
  bool _currentSortDesc = false;
  int? _currentCategoryId;
  bool? _currentIsFree;

  // Getters
  List<Course> get courses => _courses;
  List<Course> get searchResults => _searchResults;
  Course? get selectedCourse => _selectedCourse;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isSearching => _isSearching;
  String? get error => _error;
  Map<String, dynamic>? get meta => _meta;
  bool get hasCourses => _courses.isNotEmpty;
  bool get hasSearchResults => _searchResults.isNotEmpty;
  bool get hasMoreData => _hasMoreData;
  int get currentPage => _currentPage;
  int get totalCourses => _meta?['pagination']?['total'] ?? _courses.length;

  // Filter getters
  String? get currentSearchTerm => _currentSearchTerm;
  String? get currentSortField => _currentSortField;
  bool get currentSortDesc => _currentSortDesc;
  int? get currentCategoryId => _currentCategoryId;
  bool? get currentIsFree => _currentIsFree;

  /// Load courses with optional filtering
  Future<void> loadCourses({
    String? searchTerm,
    String? sortField,
    bool sortDesc = false,
    int page = 1,
    int pageSize = 25,
    int? categoryId,
    bool? isFree,
    bool refresh = false,
  }) async {
    if (refresh) {
      _resetPagination();
      _courses.clear();
    }

    if (_isLoading && !refresh) return;

    _setLoadingState(true);

    try {
      final response = await _courseService.getCourses(
        searchTerm: searchTerm,
        sortField: sortField,
        sortDesc: sortDesc,
        page: page,
        pageSize: pageSize,
        categoryId: categoryId,
        isFree: isFree,
      );

      if (response.success && response.data != null) {
        _handleSuccessfulResponse(response.data!, response.meta, refresh, page);
        _updateFilterState(searchTerm, sortField, sortDesc, categoryId, isFree);
      } else {
        _setError(response.message ?? 'Failed to load courses');
      }
    } catch (e) {
      _setError('Unexpected error occurred: $e');
    } finally {
      _setLoadingState(false);
    }
  }

  /// Load more courses (pagination)
  Future<void> loadMoreCourses() async {
    if (_isLoadingMore || !_hasMoreData || _isLoading) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _courseService.getCourses(
        searchTerm: _currentSearchTerm,
        sortField: _currentSortField,
        sortDesc: _currentSortDesc,
        page: nextPage,
        pageSize: 25,
        categoryId: _currentCategoryId,
        isFree: _currentIsFree,
      );

      if (response.success && response.data != null) {
        if (response.data!.isNotEmpty) {
          _courses.addAll(response.data!);
          _currentPage = nextPage;
          _meta = response.meta;

          // Check if there's more data
          final pagination = response.meta?['pagination'];
          if (pagination != null) {
            final currentPage = pagination['page'] ?? nextPage;
            final pageCount = pagination['pageCount'] ?? 1;
            _hasMoreData = currentPage < pageCount;
          } else {
            _hasMoreData = response.data!.length >= 25;
          }
        } else {
          _hasMoreData = false;
        }
        _error = null;
      } else {
        _setError(response.message ?? 'Failed to load more courses');
      }
    } catch (e) {
      _setError('Failed to load more courses: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Search courses
  Future<void> searchCourses(
    String searchTerm, {
    int? categoryId,
    bool? isFree,
    String? sortField,
    bool sortDesc = false,
    bool refresh = true,
  }) async {
    if (searchTerm.trim().isEmpty) {
      _searchResults.clear();
      _error = 'Search term cannot be empty';
      notifyListeners();
      return;
    }

    if (refresh) {
      _searchResults.clear();
    }

    _isSearching = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _courseService.searchCourses(
        searchTerm,
        sortField: sortField,
        sortDesc: sortDesc,
        pageSize: 50, // More results for search
      );

      if (response.success && response.data != null) {
        _searchResults = response.data!;
        _error = null;
      } else {
        _setError(response.message ?? 'Search failed');
      }
    } catch (e) {
      _setError('Search error: $e');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Get courses by category
  Future<void> loadCoursesByCategory(
    int categoryId, {
    String? sortField,
    bool sortDesc = false,
    bool refresh = true,
  }) async {
    return loadCourses(
      categoryId: categoryId,
      sortField: sortField,
      sortDesc: sortDesc,
      refresh: refresh,
    );
  }

  /// Get free courses
  Future<void> loadFreeCourses({
    String? sortField,
    bool sortDesc = false,
    bool refresh = true,
  }) async {
    return loadCourses(
      isFree: true,
      sortField: sortField,
      sortDesc: sortDesc,
      refresh: refresh,
    );
  }

  /// Get premium courses
  Future<void> loadPremiumCourses({
    String? sortField,
    bool sortDesc = false,
    bool refresh = true,
  }) async {
    return loadCourses(
      isFree: false,
      sortField: sortField,
      sortDesc: sortDesc,
      refresh: refresh,
    );
  }

  /// Get recent courses
  Future<void> loadRecentCourses({bool refresh = true}) async {
    return loadCourses(
      sortField: 'createdAt',
      sortDesc: true,
      refresh: refresh,
    );
  }

  /// Get a single course by ID
  Future<Course?> getCourseById(int id, {bool forceRefresh = false}) async {
    // First check if we already have it in our list
    if (!forceRefresh) {
      try {
        final existingCourse = _courses.firstWhere((course) => course.id == id);
        return existingCourse;
      } catch (e) {
        // Course not found in current list, continue to API call
      }
    }

    // Fetch from API
    try {
      final response = await _courseService.getCourse(id);
      if (response.success && response.data != null) {
        // Update the course in our list if it exists
        final courseIndex = _courses.indexWhere((course) => course.id == id);
        if (courseIndex != -1) {
          _courses[courseIndex] = response.data!;
          notifyListeners();
        }
        return response.data;
      } else {
        _setError(response.message ?? 'Course not found');
        return null;
      }
    } catch (e) {
      _setError('Failed to get course: $e');
      return null;
    }
  }

  /// Set selected course
  void selectCourse(Course? course) {
    _selectedCourse = course;
    notifyListeners();
  }

  /// Clear search results
  void clearSearch() {
    _searchResults.clear();
    _isSearching = false;
    notifyListeners();
  }

  /// Refresh current data
  Future<void> refresh() async {
    return loadCourses(
      searchTerm: _currentSearchTerm,
      sortField: _currentSortField,
      sortDesc: _currentSortDesc,
      categoryId: _currentCategoryId,
      isFree: _currentIsFree,
      refresh: true,
    );
  }

  /// Sort courses
  void sortCourses(String field, {bool desc = false}) {
    _courses.sort((a, b) {
      switch (field) {
        case 'title':
          return desc ? b.title.compareTo(a.title) : a.title.compareTo(b.title);
        case 'createdAt':
          return desc
              ? b.createdAt.compareTo(a.createdAt)
              : a.createdAt.compareTo(b.createdAt);
        case 'updatedAt':
          return desc
              ? b.updatedAt.compareTo(a.updatedAt)
              : a.updatedAt.compareTo(b.updatedAt);
        case 'isFree':
          return desc
              ? b.isFree.toString().compareTo(a.isFree.toString())
              : a.isFree.toString().compareTo(b.isFree.toString());
        default:
          return 0;
      }
    });

    _currentSortField = field;
    _currentSortDesc = desc;
    notifyListeners();
  }

  /// Filter courses locally
  List<Course> getFilteredCourses({
    String? searchTerm,
    int? categoryId,
    bool? isFree,
  }) {
    List<Course> filtered = List.from(_courses);

    if (searchTerm != null && searchTerm.isNotEmpty) {
      filtered = filtered
          .where(
            (course) =>
                course.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
                course.description.toLowerCase().contains(
                  searchTerm.toLowerCase(),
                ),
          )
          .toList();
    }

    if (categoryId != null) {
      filtered = filtered
          .where((course) => course.categoryId == categoryId)
          .toList();
    }

    if (isFree != null) {
      filtered = filtered.where((course) => course.isFree == isFree).toList();
    }

    return filtered;
  }

  /// Get courses by category from current list
  List<Course> getCoursesByCategory(int categoryId) {
    return _courses.where((course) => course.categoryId == categoryId).toList();
  }

  /// Get free courses from current list
  List<Course> get freeCourses {
    return _courses.where((course) => course.isFree).toList();
  }

  /// Get premium courses from current list
  List<Course> get premiumCourses {
    return _courses.where((course) => !course.isFree).toList();
  }

  /// Reset all state
  void reset() {
    _courses.clear();
    _searchResults.clear();
    _selectedCourse = null;
    _isLoading = false;
    _isLoadingMore = false;
    _isSearching = false;
    _error = null;
    _meta = null;
    _resetPagination();
    _resetFilterState();
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Private helper methods
  void _setLoadingState(bool loading) {
    _isLoading = loading;
    if (loading) {
      _error = null;
    }
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _handleSuccessfulResponse(
    List<Course> data,
    Map<String, dynamic>? meta,
    bool refresh,
    int page,
  ) {
    if (refresh || _courses.isEmpty) {
      _courses = data;
      _currentPage = page;
    } else {
      _courses.addAll(data);
      _currentPage = page;
    }

    _meta = meta;
    _error = null;

    // Update pagination state
    if (meta != null) {
      final pagination = meta['pagination'];
      if (pagination != null) {
        final currentPage = pagination['page'] ?? page;
        final pageCount = pagination['pageCount'] ?? 1;
        _hasMoreData = currentPage < pageCount;
      }
    } else {
      _hasMoreData = data.length >= 25; // Default page size
    }
  }

  void _updateFilterState(
    String? searchTerm,
    String? sortField,
    bool sortDesc,
    int? categoryId,
    bool? isFree,
  ) {
    _currentSearchTerm = searchTerm;
    _currentSortField = sortField;
    _currentSortDesc = sortDesc;
    _currentCategoryId = categoryId;
    _currentIsFree = isFree;
  }

  void _resetPagination() {
    _currentPage = 1;
    _hasMoreData = true;
  }

  void _resetFilterState() {
    _currentSearchTerm = null;
    _currentSortField = null;
    _currentSortDesc = false;
    _currentCategoryId = null;
    _currentIsFree = null;
  }
}
