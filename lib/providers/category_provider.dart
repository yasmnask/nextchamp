import 'package:flutter/foundation.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _meta;

  // Getters
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get meta => _meta;
  bool get hasCategories => _categories.isNotEmpty;

  // Load categories
  Future<void> loadCategories({
    String? searchTerm,
    String? sortField,
    bool sortDesc = false,
    int page = 1,
    int pageSize = 4,
    bool refresh = false,
  }) async {
    if (refresh) {
      _categories = [];
    }

    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _categoryService.getCategories(
        searchTerm: searchTerm,
        sortField: sortField,
        sortDesc: sortDesc,
        page: page,
        pageSize: pageSize,
      );

      if (response.success && response.data != null) {
        if (refresh || _categories.isEmpty) {
          _categories = response.data!;
        } else {
          _categories.addAll(response.data!);
        }
        _meta = response.meta;
        _error = null;
      } else {
        _error = response.message ?? 'Failed to load categories';
      }
    } catch (e) {
      _error = 'Unexpected error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get a single category by ID
  Future<CategoryModel?> getCategoryById(int id) async {
    // First check if we already have it in our list
    final existingCategory = _categories.firstWhere(
      (category) => category.id == id,
      orElse: () => CategoryModel(
        id: -1,
        name: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    if (existingCategory.id != -1) {
      return existingCategory;
    }

    // Otherwise fetch it from the API
    try {
      final response = await _categoryService.getCategory(id);
      if (response.success && response.data != null) {
        return response.data;
      }
      return null;
    } catch (e) {
      _error = 'Failed to get category: $e';
      notifyListeners();
      return null;
    }
  }

  // Reset state
  void reset() {
    _categories = [];
    _isLoading = false;
    _error = null;
    _meta = null;
    notifyListeners();
  }
}
