import 'package:dio/dio.dart';
import '../core/dio_client.dart';
import '../models/course_model.dart';
import '../utils/api_response.dart';
import '../utils/strapi_query_helper.dart';

class CourseService {
  final _dio = DioClient().dio;
  final String _endpoint = '/courses';

  /// Get all courses with optional filtering and pagination
  Future<ApiResponse<List<Course>>> getCourses({
    String? searchTerm,
    String? sortField,
    bool sortDesc = false,
    int? page,
    int? pageSize,
    int? categoryId,
    bool? isFree,
  }) async {
    try {
      final queryString = StrapiQueryHelper.buildCourseQuery(
        searchTerm: searchTerm,
        sortField: sortField,
        sortDesc: sortDesc,
        page: page,
        pageSize: pageSize,
        categoryId: categoryId,
        isFree: isFree,
      );

      final response = await _dio.get('$_endpoint?$queryString');

      // Handle Strapi v4 response format
      final data = response.data;

      if (data == null) {
        return ApiResponse.error('No data received from server');
      }

      final List<dynamic> coursesData = data['data'] ?? [];
      final meta = data['meta'];

      final courses = coursesData
          .map((courseJson) {
            try {
              return Course.fromJson(courseJson);
            } catch (e) {
              // Log the error but continue processing other courses
              print('Error parsing course: $e');
              return null;
            }
          })
          .where((course) => course != null)
          .cast<Course>()
          .toList();

      return ApiResponse.success(courses, meta: meta);
    } on DioException catch (e) {
      return _handleDioException(e, 'Failed to fetch courses');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  /// Get a single course by ID
  Future<ApiResponse<Course>> getCourse(int id) async {
    try {
      // Add populate parameter for related data
      final queryString = StrapiQueryHelper.buildSingleCourseQuery();
      final response = await _dio.get('$_endpoint/$id?$queryString');

      final data = response.data;

      if (data == null) {
        return ApiResponse.error('No data received from server');
      }

      // Handle both Strapi v4 format and direct format
      final courseData = data['data'] ?? data;
      final course = Course.fromJson(courseData);

      return ApiResponse.success(course);
    } on DioException catch (e) {
      return _handleDioException(e, 'Failed to fetch course');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  /// Get courses by category
  Future<ApiResponse<List<Course>>> getCoursesByCategory(
    int categoryId, {
    int? page,
    int? pageSize,
    String? sortField,
    bool sortDesc = false,
  }) async {
    return getCourses(
      categoryId: categoryId,
      page: page,
      pageSize: pageSize,
      sortField: sortField,
      sortDesc: sortDesc,
    );
  }

  /// Get free courses only
  Future<ApiResponse<List<Course>>> getFreeCourses({
    int? page,
    int? pageSize,
    String? sortField,
    bool sortDesc = false,
  }) async {
    return getCourses(
      isFree: true,
      page: page,
      pageSize: pageSize,
      sortField: sortField,
      sortDesc: sortDesc,
    );
  }

  /// Get premium courses only
  Future<ApiResponse<List<Course>>> getPremiumCourses({
    int? page,
    int? pageSize,
    String? sortField,
    bool sortDesc = false,
  }) async {
    return getCourses(
      isFree: false,
      page: page,
      pageSize: pageSize,
      sortField: sortField,
      sortDesc: sortDesc,
    );
  }

  /// Search courses by title or description
  Future<ApiResponse<List<Course>>> searchCourses(
    String searchTerm, {
    int? page,
    int? pageSize,
    String? sortField,
    bool sortDesc = false,
  }) async {
    if (searchTerm.trim().isEmpty) {
      return ApiResponse.error('Search term cannot be empty');
    }

    return getCourses(
      searchTerm: searchTerm,
      page: page,
      pageSize: pageSize,
      sortField: sortField,
      sortDesc: sortDesc,
    );
  }

  /// Get recently added courses
  Future<ApiResponse<List<Course>>> getRecentCourses({
    int? pageSize = 10,
  }) async {
    return getCourses(
      sortField: 'createdAt',
      sortDesc: true,
      pageSize: pageSize,
    );
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
