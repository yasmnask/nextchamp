import 'package:dio/dio.dart';
import 'package:nextchamp/utils/strapi_query_builder.dart';
import '../core/dio_client.dart';
import '../models/category_model.dart';
import '../utils/api_response.dart';
import '../utils/strapi_query_helper.dart';

class CategoryService {
  final _dio = DioClient().dio;
  final String _endpoint = '/categories';

  /// Get all categories with optional filtering and pagination
  Future<ApiResponse<List<CategoryModel>>> getCategories({
    String? searchTerm,
    String? sortField,
    bool sortDesc = false,
    int? page,
    int? pageSize,
    bool includeIcon = true,
  }) async {
    try {
      final queryString = StrapiQueryHelper.buildCategoryQuery(
        searchTerm: searchTerm,
        sortField: sortField,
        sortDesc: sortDesc,
        page: page,
        pageSize: pageSize,
      );

      final response = await _dio.get('$_endpoint?$queryString');

      // Handle Strapi v4 response format
      final data = response.data;

      if (data == null) {
        return ApiResponse.error('No data received from server');
      }

      final List<dynamic> categoriesData = data['data'] ?? [];
      final meta = data['meta'];

      final categories = categoriesData
          .map((categoryJson) {
            try {
              return CategoryModel.fromJson(categoryJson);
            } catch (e) {
              // Log the error but continue processing other categories
              print('Error parsing category: $e');
              return null;
            }
          })
          .where((category) => category != null)
          .cast<CategoryModel>()
          .toList();

      return ApiResponse.success(categories, meta: meta);
    } on DioException catch (e) {
      return _handleDioException(e, 'Failed to fetch categories');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  /// Get a single category by ID
  Future<ApiResponse<CategoryModel>> getCategory(int id) async {
    try {
      // Add populate parameter for related data
      final queryString = StrapiQueryHelper.buildSingleCategoryQuery();
      final response = await _dio.get('$_endpoint/$id?$queryString');

      final data = response.data;

      if (data == null) {
        return ApiResponse.error('No data received from server');
      }

      // Handle both Strapi v4 format and direct format
      final categoryData = data['data'] ?? data;
      final category = CategoryModel.fromJson(categoryData);

      return ApiResponse.success(category);
    } on DioException catch (e) {
      return _handleDioException(e, 'Failed to fetch category');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  /// Get categories by multiple IDs
  Future<ApiResponse<List<CategoryModel>>> getCategoriesByIds(
    List<int> ids,
  ) async {
    try {
      if (ids.isEmpty) {
        return ApiResponse.success([]);
      }

      final queryBuilder = StrapiQueryBuilder();

      // Build filter for multiple IDs
      for (int i = 0; i < ids.length; i++) {
        if (i == 0) {
          queryBuilder.filter('id', ids[i]);
        } else {
          queryBuilder.orEq('id', ids[i]);
        }
      }

      // Add populate for icon if needed
      queryBuilder.populateField('icon', fields: ['url', 'alternativeText']);

      final response = await _dio.get('$_endpoint?${queryBuilder.build()}');

      final data = response.data;

      if (data == null) {
        return ApiResponse.error('No data received from server');
      }

      final List<dynamic> categoriesData = data['data'] ?? [];
      final meta = data['meta'];

      final categories = categoriesData
          .map((categoryJson) {
            try {
              return CategoryModel.fromJson(categoryJson);
            } catch (e) {
              print('Error parsing category: $e');
              return null;
            }
          })
          .where((category) => category != null)
          .cast<CategoryModel>()
          .toList();

      return ApiResponse.success(categories, meta: meta);
    } on DioException catch (e) {
      return _handleDioException(e, 'Failed to fetch categories');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  /// Search categories by name or title
  Future<ApiResponse<List<CategoryModel>>> searchCategories(
    String searchTerm, {
    int? page,
    int? pageSize,
    String? sortField,
    bool sortDesc = false,
  }) async {
    if (searchTerm.trim().isEmpty) {
      return ApiResponse.error('Search term cannot be empty');
    }

    return getCategories(
      searchTerm: searchTerm,
      page: page,
      pageSize: pageSize,
      sortField: sortField,
      sortDesc: sortDesc,
    );
  }

  /// Get categories with course count (if your API supports aggregation)
  Future<ApiResponse<List<CategoryModel>>> getCategoriesWithCourseCount({
    String? sortField,
    bool sortDesc = false,
    int? page,
    int? pageSize,
  }) async {
    try {
      final queryBuilder = StrapiQueryBuilder();

      // Add sorting
      if (sortField != null) {
        queryBuilder.sortBy(sortField, desc: sortDesc);
      } else {
        queryBuilder.sortBy('name', desc: false); // Default sort by name
      }

      // Add pagination if provided
      if (page != null && pageSize != null) {
        queryBuilder.paginate(page, pageSize);
      }

      // Select fields
      queryBuilder.select(['name', 'title', 'description']);

      // Populate icon and courses count
      queryBuilder.populateField('icon', fields: ['url', 'alternativeText']);
      queryBuilder.populateField(
        'courses',
        fields: ['id'],
      ); // Only get IDs for count

      final response = await _dio.get('$_endpoint?${queryBuilder.build()}');

      final data = response.data;

      if (data == null) {
        return ApiResponse.error('No data received from server');
      }

      final List<dynamic> categoriesData = data['data'] ?? [];
      final meta = data['meta'];

      final categories = categoriesData
          .map((categoryJson) {
            try {
              return CategoryModel.fromJson(categoryJson);
            } catch (e) {
              print('Error parsing category: $e');
              return null;
            }
          })
          .where((category) => category != null)
          .cast<CategoryModel>()
          .toList();

      return ApiResponse.success(categories, meta: meta);
    } on DioException catch (e) {
      return _handleDioException(
        e,
        'Failed to fetch categories with course count',
      );
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  /// Create a new category (if your API supports it)
  Future<ApiResponse<CategoryModel>> createCategory(
    CategoryModel category,
  ) async {
    try {
      final categoryData = category.toJson();
      // Remove read-only fields
      categoryData.remove('id');
      categoryData.remove('createdAt');
      categoryData.remove('updatedAt');

      final response = await _dio.post(_endpoint, data: {'data': categoryData});

      final data = response.data;
      if (data == null) {
        return ApiResponse.error('No data received from server');
      }

      final newCategoryData = data['data'] ?? data;
      final newCategory = CategoryModel.fromJson(newCategoryData);

      return ApiResponse.success(newCategory);
    } on DioException catch (e) {
      return _handleDioException(e, 'Failed to create category');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  /// Update an existing category (if your API supports it)
  Future<ApiResponse<CategoryModel>> updateCategory(
    int id,
    CategoryModel category,
  ) async {
    try {
      final categoryData = category.toJson();
      // Remove read-only fields
      categoryData.remove('id');
      categoryData.remove('createdAt');
      categoryData.remove('updatedAt');

      final response = await _dio.put(
        '$_endpoint/$id',
        data: {'data': categoryData},
      );

      final data = response.data;
      if (data == null) {
        return ApiResponse.error('No data received from server');
      }

      final updatedCategoryData = data['data'] ?? data;
      final updatedCategory = CategoryModel.fromJson(updatedCategoryData);

      return ApiResponse.success(updatedCategory);
    } on DioException catch (e) {
      return _handleDioException(e, 'Failed to update category');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  /// Delete a category (if your API supports it)
  Future<ApiResponse<bool>> deleteCategory(int id) async {
    try {
      await _dio.delete('$_endpoint/$id');
      return ApiResponse.success(true);
    } on DioException catch (e) {
      return _handleDioException(e, 'Failed to delete category');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  /// Handle DioException with consistent error messages
  ApiResponse<T> _handleDioException<T>(DioException e, String defaultMessage) {
    switch (e.response?.statusCode) {
      case 400:
        return ApiResponse.error(
          'Bad request: ${e.response?.data?['error']?['message'] ?? 'Invalid parameters'}',
        );
      case 401:
        return ApiResponse.error(
          'Unauthorized: Please check your authentication',
        );
      case 403:
        return ApiResponse.error(
          'Forbidden: You don\'t have permission to access this resource',
        );
      case 404:
        return ApiResponse.error('Resource not found');
      case 409:
        return ApiResponse.error('Conflict: Resource already exists');
      case 422:
        return ApiResponse.error(
          'Validation error: ${e.response?.data?['error']?['message'] ?? 'Invalid data'}',
        );
      case 429:
        return ApiResponse.error('Too many requests: Please try again later');
      case 500:
        return ApiResponse.error('Server error: Please try again later');
      case 503:
        return ApiResponse.error(
          'Service unavailable: Server is temporarily down',
        );
      default:
        if (e.type == DioExceptionType.connectionTimeout) {
          return ApiResponse.error(
            'Connection timeout: Please check your internet connection',
          );
        } else if (e.type == DioExceptionType.receiveTimeout) {
          return ApiResponse.error(
            'Request timeout: Server is taking too long to respond',
          );
        } else if (e.type == DioExceptionType.connectionError) {
          return ApiResponse.error(
            'Connection error: Please check your internet connection',
          );
        }
        return ApiResponse.error(
          '$defaultMessage: ${e.message ?? 'Unknown error'}',
        );
    }
  }
}
