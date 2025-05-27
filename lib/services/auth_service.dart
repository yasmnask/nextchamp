import 'dio_client.dart';
import '../core/secure_storage.dart';

class AuthService {
  final _dio = DioClient().dio;

  Future<bool> login(String identifier, String password) async {
    try {
      final response = await _dio.post(
        '/auth/local',
        data: {'identifier': identifier, 'password': password},
      );

      final token = response.data['jwt'];
      await SecureStorage.saveToken(token);
      return true;
    } catch (e) {
      print('Login failed: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await SecureStorage.clearToken();
  }
}
