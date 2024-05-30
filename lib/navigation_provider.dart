import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  final PageController _pageController = PageController();

  PageController get pageController => _pageController;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int newIndex) {
    _currentIndex = newIndex;
    _pageController.jumpToPage(newIndex);
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
