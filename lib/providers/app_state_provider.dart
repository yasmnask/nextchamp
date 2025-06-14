import 'package:flutter/foundation.dart';

class AppStateProvider extends ChangeNotifier {
  int? selectedCategoryId;
  String? selectedCategoryName;

  void setSelectedCategory(int? id, String? name) {
    selectedCategoryId = id;
    selectedCategoryName = name;
    notifyListeners();
  }

  void clearCategory() {
    selectedCategoryId = null;
    selectedCategoryName = null;
    notifyListeners();
  }
}
