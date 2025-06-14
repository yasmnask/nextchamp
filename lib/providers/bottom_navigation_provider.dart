import 'package:flutter/foundation.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int _currentIndex = 2;
  int get currentIndex => _currentIndex;

  void setPage(int newIndex) {
    if (_currentIndex != newIndex) {
      _currentIndex = newIndex;
      notifyListeners();
    }
  }
}
