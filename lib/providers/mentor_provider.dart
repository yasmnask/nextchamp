import 'package:flutter/foundation.dart';
import '../models/mentor_model.dart';
import '../services/mentor_service.dart';

class MentorProvider with ChangeNotifier {
  final MentorService _mentorService = MentorService();

  List<Mentor> _mentors = [];
  List<Mentor> _featuredMentors = [];
  List<Mentor> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Mentor> get mentors => _mentors;
  List<Mentor> get featuredMentors => _featuredMentors;
  List<Mentor> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all mentors
  Future<void> loadMentors({
    bool refresh = false,
    String? sortField,
    bool sortDesc = false,
    int? categoryId,
  }) async {
    if (_isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      final response = await _mentorService.getMentors(
        sortField: sortField ?? 'createdAt',
        sortDesc: sortDesc,
        categoryId: categoryId,
      );

      if (response.success && response.data != null) {
        _mentors = response.data!;
      } else {
        _setError(response.message ?? 'Failed to load mentors');
      }
    } catch (e) {
      _setError('Unexpected error: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load featured mentors
  Future<void> loadFeaturedMentors({bool refresh = false}) async {
    if (_isLoading && !refresh) return;

    _setLoading(true);
    _clearError();

    try {
      final response = await _mentorService.getFeaturedMentors();

      if (response.success && response.data != null) {
        _featuredMentors = response.data!;
      } else {
        _setError(response.message ?? 'Failed to load featured mentors');
      }
    } catch (e) {
      _setError('Unexpected error: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Search mentors
  Future<void> searchMentors(
    String searchTerm, {
    int? categoryId,
    String? sortField,
    bool sortDesc = false,
  }) async {
    if (searchTerm.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      final response = await _mentorService.searchMentors(
        searchTerm,
        categoryId: categoryId,
        sortField: sortField ?? 'createdAt',
        sortDesc: sortDesc,
      );

      if (response.success && response.data != null) {
        _searchResults = response.data!;
      } else {
        _setError(response.message ?? 'Search failed');
        _searchResults = [];
      }
    } catch (e) {
      _setError('Search error: $e');
      _searchResults = [];
    } finally {
      _setLoading(false);
    }
  }

  /// Filter mentors by category
  Future<void> filterByCategory(
    int? categoryId, {
    String? sortField,
    bool sortDesc = false,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _mentorService.getMentors(
        categoryId: categoryId,
        sortField: sortField ?? 'createdAt',
        sortDesc: sortDesc,
      );

      if (response.success && response.data != null) {
        _mentors = response.data!;
      } else {
        _setError(response.message ?? 'Failed to filter mentors');
      }
    } catch (e) {
      _setError('Filter error: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Clear search results
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  /// Refresh all data
  Future<void> refresh() async {
    await Future.wait([
      loadMentors(refresh: true),
      loadFeaturedMentors(refresh: true),
    ]);
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
