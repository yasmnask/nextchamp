import 'package:flutter/material.dart';
import 'package:nextchamp/models/user_model.dart';
import 'package:nextchamp/core/secure_storage.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> loadUser() async {
    final storedUser = await SecureStorage.getUser();
    if (storedUser != null) {
      _user = storedUser;
      notifyListeners();
    }
  }

  Future<void> setUser(User user) async {
    _user = user;
    notifyListeners();
  }

  Future<void> clearUser() async {
    _user = null;
    notifyListeners();
  }
}
