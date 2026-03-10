import 'package:flutter/material.dart';

class HomeTabsProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    if (_currentIndex == index) {
      return;
    }
    _currentIndex = index;
    notifyListeners();
  }
}
