import 'package:dio/dio.dart';
import 'dio_client.dart';
import '../models/api_response.dart';

class StrapiService {
  final _dio = DioClient().dio;

  // Generic method to fetch collection data
  Future<ApiResponse<List<T>>> getCollection<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParams);

      final List<dynamic> dataList = response.data['data'] ?? [];
      final List<T> items = dataList.map((item) => fromJson(item)).toList();

      return ApiResponse.success(items, meta: response.data['meta']);
    } on DioException catch (e) {
      return ApiResponse.error('Failed to fetch data: ${e.message}');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred');
    }
  }

  // Generic method to fetch single item
  Future<ApiResponse<T>> getSingle<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      final T item = fromJson(response.data['data']);

      return ApiResponse.success(item, meta: response.data['meta']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return ApiResponse.error('Item not found');
      }
      return ApiResponse.error('Failed to fetch item: ${e.message}');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred');
    }
  }

  // Generic method to create item
  Future<ApiResponse<T>> create<T>(
    String endpoint,
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await _dio.post(endpoint, data: {'data': data});
      final T item = fromJson(response.data['data']);

      return ApiResponse.success(item, message: 'Item created successfully');
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return ApiResponse.error('Invalid data provided');
      } else if (e.response?.statusCode == 401) {
        return ApiResponse.error('Unauthorized');
      } else if (e.response?.statusCode == 403) {
        return ApiResponse.error('Forbidden');
      }
      return ApiResponse.error('Failed to create item: ${e.message}');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred');
    }
  }

  // Generic method to update item
  Future<ApiResponse<T>> update<T>(
    String endpoint,
    int id,
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await _dio.put('$endpoint/$id', data: {'data': data});
      final T item = fromJson(response.data['data']);

      return ApiResponse.success(item, message: 'Item updated successfully');
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return ApiResponse.error('Invalid data provided');
      } else if (e.response?.statusCode == 401) {
        return ApiResponse.error('Unauthorized');
      } else if (e.response?.statusCode == 403) {
        return ApiResponse.error('Forbidden');
      } else if (e.response?.statusCode == 404) {
        return ApiResponse.error('Item not found');
      }
      return ApiResponse.error('Failed to update item: ${e.message}');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred');
    }
  }

  // Generic method to delete item
  Future<ApiResponse<bool>> delete(String endpoint, int id) async {
    try {
      await _dio.delete('$endpoint/$id');
      return ApiResponse.success(true, message: 'Item deleted successfully');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error('Unauthorized');
      } else if (e.response?.statusCode == 403) {
        return ApiResponse.error('Forbidden');
      } else if (e.response?.statusCode == 404) {
        return ApiResponse.error('Item not found');
      }
      return ApiResponse.error('Failed to delete item: ${e.message}');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred');
    }
  }

  // File upload method
  Future<ApiResponse<Map<String, dynamic>>> uploadFile(
    String filePath,
    String fileName,
  ) async {
    try {
      final formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await _dio.post('/upload', data: formData);

      return ApiResponse.success(
        response.data[0],
        message: 'File uploaded successfully',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 413) {
        return ApiResponse.error('File too large');
      } else if (e.response?.statusCode == 415) {
        return ApiResponse.error('Unsupported file type');
      }
      return ApiResponse.error('Failed to upload file: ${e.message}');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred');
    }
  }
}
