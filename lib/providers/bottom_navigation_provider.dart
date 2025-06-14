import 'package:flutter/foundation.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int _currentIndex = 2;
  bool _champBotConfig = false;
  int get currentIndex => _currentIndex;
  bool get champBotConfig => _champBotConfig;

  void setPage(int newIndex) {
    if (_currentIndex != newIndex) {
      _champBotConfig = false;
      _currentIndex = newIndex;
      notifyListeners();
    } else {
      _champBotConfig = true;
      notifyListeners();
    }
  }
}
