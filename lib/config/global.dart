import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalConfig extends ChangeNotifier {
  static final GlobalConfig _instance = GlobalConfig._internal();
  factory GlobalConfig() => _instance;
  GlobalConfig._internal();

  SharedPreferences? _prefs;
  bool _isDisabilityMode = false;

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    _isDisabilityMode = _prefs?.getBool('isDisabilityMode') ?? false;
  }

  bool get isDisabilityMode => _isDisabilityMode;

  Future<void> markLaunched({required bool isDisabilityMode}) async {
    await initialize();
    await _prefs?.setBool('isFirstLaunch', false);
    await setDisabilityMode(isDisabilityMode);
  }

  Future<bool> isFirstLaunch() async {
    await initialize();
    return _prefs?.getBool('isFirstLaunch') ?? true;
  }

  Future<void> setDisabilityMode(bool value) async {
    await initialize();
    _isDisabilityMode = value;
    await _prefs?.setBool('isDisabilityMode', value);
    notifyListeners(); 
  }

  Future<void> toggleDisabilityMode() async {
    await initialize();
    final toggled = !_isDisabilityMode;
    await setDisabilityMode(toggled);
  }
}
