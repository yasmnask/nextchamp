import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'authToken', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'authToken');
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: 'authToken');
  }
}
