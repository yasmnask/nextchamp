import 'package:dio/dio.dart';
import '../core/dio_client.dart';
import '../models/mentor_model.dart';
import '../utils/api_response.dart';
import '../utils/strapi_query_helper.dart';

class MentorService {
  final _dio = DioClient().dio;
  final String _endpoint = '/mentors';

  /// Get all mentors with optional filtering and pagination
  Future<ApiResponse<List<Mentor>>> getMentors({
    String? searchTerm,
    String? sortField,
    bool sortDesc = false,
    int? page,
    int? pageSize,
    int? categoryId,
    bool? isFeatured,
  }) async {
    try {
      final queryString = StrapiQueryHelper.buildMentorQuery(
        searchTerm: searchTerm,
        sortField: sortField,
        sortDesc: sortDesc,
        page: page,
        pageSize: pageSize,
        categoryId: categoryId,
        isFeatured: isFeatured,
      );

      final response = await _dio.get('$_endpoint?$queryString');

      // Handle Strapi v4 response format
      final data = response.data;

      if (data == null) {
        return ApiResponse.error('No data received from server');
      }

      final List<dynamic> mentorsData = data['data'] ?? [];
      final meta = data['meta'];

      final mentors = mentorsData
          .map((mentorJson) {
            try {
              return Mentor.fromJson(mentorJson);
            } catch (e) {
              print('Error parsing mentor: $e');
              return null;
            }
          })
          .where((mentor) => mentor != null)
          .cast<Mentor>()
          .toList();

      return ApiResponse.success(mentors, meta: meta);
    } on DioException catch (e) {
      return _handleDioException(e, 'Failed to fetch mentors');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  /// Get featured mentors
  Future<ApiResponse<List<Mentor>>> getFeaturedMentors({
    int? pageSize = 10,
  }) async {
    return getMentors(
      isFeatured: true,
      sortField: 'createdAt',
      sortDesc: true,
      pageSize: pageSize,
    );
  }

  /// Get regular mentors (non-featured)
  Future<ApiResponse<List<Mentor>>> getRegularMentors({
    int? page,
    int? pageSize,
    String? sortField,
    bool sortDesc = false,
    int? categoryId,
  }) async {
    return getMentors(
      isFeatured: false,
      page: page,
      pageSize: pageSize,
      sortField: sortField,
      sortDesc: sortDesc,
      categoryId: categoryId,
    );
  }

  /// Search mentors by name or description
  Future<ApiResponse<List<Mentor>>> searchMentors(
    String searchTerm, {
    int? categoryId,
    int? page,
    int? pageSize,
    String? sortField,
    bool sortDesc = false,
  }) async {
    if (searchTerm.trim().isEmpty) {
      return ApiResponse.error('Search term cannot be empty');
    }

    return getMentors(
      searchTerm: searchTerm,
      categoryId: categoryId,
      page: page,
      pageSize: pageSize,
      sortField: sortField,
      sortDesc: sortDesc,
    );
  }

  /// Get mentors by category
  Future<ApiResponse<List<Mentor>>> getMentorsByCategory(
    int categoryId, {
    int? page,
    int? pageSize,
    String? sortField,
    bool sortDesc = false,
  }) async {
    return getMentors(
      categoryId: categoryId,
      page: page,
      pageSize: pageSize,
      sortField: sortField,
      sortDesc: sortDesc,
    );
  }

  /// Get a single mentor by ID
  Future<ApiResponse<Mentor>> getMentor(int id) async {
    try {
      final queryString = StrapiQueryHelper.buildSingleMentorQuery();
      final response = await _dio.get('$_endpoint/$id?$queryString');

      final data = response.data;

      if (data == null) {
        return ApiResponse.error('No data received from server');
      }

      final mentorData = data['data'] ?? data;
      final mentor = Mentor.fromJson(mentorData);

      return ApiResponse.success(mentor);
    } on DioException catch (e) {
      return _handleDioException(e, 'Failed to fetch mentor');
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
