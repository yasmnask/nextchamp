import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/user_model.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Token management
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'authToken', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'authToken');
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: 'authToken');
  }

  // User management
  static Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: 'currentUser', value: userJson);
  }

  static Future<User?> getUser() async {
    final userJson = await _storage.read(key: 'currentUser');
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      } catch (e) {
        // If parsing fails, clear the corrupted data
        await clearUser();
        return null;
      }
    }
    return null;
  }

  static Future<void> clearUser() async {
    await _storage.delete(key: 'currentUser');
  }

  // Settings management
  static Future<void> saveSetting(String key, String value) async {
    await _storage.write(key: 'setting_$key', value: value);
  }

  static Future<String?> getSetting(String key) async {
    return await _storage.read(key: 'setting_$key');
  }

  static Future<void> clearSetting(String key) async {
    await _storage.delete(key: 'setting_$key');
  }

  // Clear all data
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    final user = await getUser();
    return token != null && user != null;
  }
}
