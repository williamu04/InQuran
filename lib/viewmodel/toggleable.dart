import 'package:flutter/material.dart';

class ToggleableUiController extends ChangeNotifier {

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

class ErrorPopUpController extends ToggleableUiController {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  @override
  void open([String? error]) {
    debugPrint("HELLO FROM CONTROLLER $error");
    _errorMessage = error;
    notifyListeners();
    super.open(); 
  }

  @override
  void close() {
    _errorMessage = null; 
    super.close();
  }
}

class SettingSlideDrawer extends ToggleableUiController {}
class MenuSlideDrawer extends ToggleableUiController {}
class LogoutDialoguePopUp extends ToggleableUiController {}
class LogoutLoading extends ToggleableUiController {}
class UnauthenticatedPopUp extends ToggleableUiController {}