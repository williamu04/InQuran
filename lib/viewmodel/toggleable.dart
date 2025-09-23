import 'package:flutter/material.dart';

class ToggleableUiViewModel extends ChangeNotifier {

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

abstract class ErrorPopUpViewModel extends ToggleableUiViewModel {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  @override
  void open([String? error]) {
    _errorMessage = error;
    super.open(); 
  }

  @override
  void close() {
    _errorMessage = null; 
    super.close();
  }
}

class SettingSlideDrawer extends ToggleableUiViewModel {}
class MenuSlideDrawer extends ToggleableUiViewModel {}
class UnauthenticatedPopUp extends ToggleableUiViewModel {}
class LogoutDialoguePopUp extends ToggleableUiViewModel {}
class LogoutErrorPopUp extends ErrorPopUpViewModel {

}
class LoginErrorPopUp extends ErrorPopUpViewModel {}
class SignInErrorPopUp extends ErrorPopUpViewModel {}
