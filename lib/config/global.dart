import 'package:shared_preferences/shared_preferences.dart';

class GlobalConfig {
  static final GlobalConfig _instance = GlobalConfig._internal();
  factory GlobalConfig() => _instance;
  GlobalConfig._internal();

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> isFirstLaunch() async {
    await initialize(); 
    return _prefs?.getBool('isFirstLaunch') ?? true;
  }

  Future<void> markLaunched() async {
    await initialize();
    await _prefs?.setBool('isFirstLaunch', false);
  }
}
