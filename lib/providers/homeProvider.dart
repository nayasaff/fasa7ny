import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  List<String> _activeChips = [];

  List<String> getActiveChips() {
    return _activeChips;
  }

  void addItem(String category) {
    _activeChips.add(category);
    notifyListeners();
  }

  void removeItem(String category) {
    _activeChips.remove(category);
    notifyListeners();
  }

  String toString() {
    return 'categories: $_activeChips';
  }
}
