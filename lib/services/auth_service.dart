import 'package:dio/dio.dart';
import 'dio_client.dart';
import '../core/secure_storage.dart';
import '../models/user_model.dart';
import '../models/api_response.dart';

class AuthService {
  final _dio = DioClient().dio;

  Future<ApiResponse<Map<String, dynamic>>> login(
    String identifier,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/local',
        data: {'identifier': identifier, 'password': password},
      );

      final token = response.data['jwt'];
      final user = User.fromJson(response.data['user']);

      await SecureStorage.saveToken(token);
      await SecureStorage.saveUser(user);

      return ApiResponse.success({
        'token': token,
        'user': user,
      }, message: 'Login successful');
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return ApiResponse.error('Invalid credentials');
      } else if (e.response?.statusCode == 429) {
        return ApiResponse.error('Too many attempts. Please try again later.');
      }
      return ApiResponse.error('Login failed: ${e.message}');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/local/register',
        data: {'username': username, 'email': email, 'password': password},
      );

      final token = response.data['jwt'];
      final user = response.data['user'];

      await SecureStorage.saveToken(token);

      return ApiResponse.success({
        'token': token,
        'user': user,
      }, message: 'Registration successful');
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errors = e.response?.data['error']?['details']?['errors'];
        if (errors != null) {
          final errorMessages = errors
              .map<String>((error) => error['message'])
              .toList();
          return ApiResponse.error(
            'Registration failed',
            errors: errorMessages,
          );
        }
        return ApiResponse.error('Registration failed: Invalid data');
      }
      return ApiResponse.error('Registration failed: ${e.message}');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred');
    }
  }

  Future<ApiResponse<User>> getCurrentUser() async {
    try {
      final response = await _dio.get('/users/me');
      final user = User.fromJson(response.data);
      await SecureStorage.saveUser(user);

      return ApiResponse.success(user);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await logout();
        return ApiResponse.error('Session expired');
      }
      return ApiResponse.error('Failed to get user: ${e.message}');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred');
    }
  }

  Future<ApiResponse<User>> updateProfile({
    String? username,
    String? email,
    String? fullname,
    required int? id,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (username != null) data['username'] = username;
      if (email != null) data['email'] = email;
      if (fullname != null) data['fullname'] = fullname;

      final response = await _dio.put('/users/' + id.toString(), data: data);
      final user = User.fromJson(response.data);
      await SecureStorage.saveUser(user);

      return ApiResponse.success(user, message: 'Profile updated successfully');
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return ApiResponse.error('Invalid profile data');
      } else if (e.response?.statusCode == 401) {
        await logout();
        return ApiResponse.error('Session expired');
      }
      return ApiResponse.error('Failed to update profile: ${e.message}');
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred');
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await SecureStorage.getToken();
    if (token == null) return false;

    try {
      final response = await getCurrentUser();
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await SecureStorage.clearToken();
    await SecureStorage.clearUser();
    await SecureStorage.clearAll();
  }
}
