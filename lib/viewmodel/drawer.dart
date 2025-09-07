import 'package:flutter/material.dart';

class SlideDrawerViewModel extends ChangeNotifier {

  bool _isOpen = false;
  bool get isOpen => _isOpen;

  void open() {
    _isOpen = true;
    notifyListeners();
  }

  void close() {
    _isOpen = false;
    notifyListeners();
  }

  void toggle() {
    _isOpen = !_isOpen;
    notifyListeners();
  }
}

class SettingSlideDrawerViewModel extends SlideDrawerViewModel {
}

class MenuSlideDrawerViewModel extends SlideDrawerViewModel {
}
