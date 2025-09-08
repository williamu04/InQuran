import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum QuranMode {normal, memorize, mushaf}

class GlobalConfig extends ChangeNotifier {
  static final GlobalConfig _instance = GlobalConfig._internal();
  factory GlobalConfig() => _instance;
  GlobalConfig._internal();

  SharedPreferences? _prefs;

  QuranMode _quranMode = QuranMode.normal;
  bool _isVoiceMode = false;
  bool _isFirstLaunch = true;

  bool get isFirstLaunch => _isFirstLaunch;
  bool get isVoiceMode => _isVoiceMode;
  QuranMode get quranMode => _quranMode;

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    _isFirstLaunch = _prefs!.getBool('isFirstLaunch') ?? true;
    _isVoiceMode = _prefs!.getBool('isVoiceMode') ?? false;
    final string = _prefs!.getString('quranMode') ?? QuranMode.normal.name;
    _quranMode = QuranMode.values.firstWhere(
      (e) => e.name == string,
      orElse: () => QuranMode.normal,
    );
  }

  Future<void> setQuranMode(QuranMode mode) async {
    _prefs ??= await SharedPreferences.getInstance();
    _quranMode = mode;
    await _prefs?.setString('quranMode', mode.name); 
    notifyListeners();
  }

  Future<void> setVoiceMode(bool value) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setBool('isVoiceMode', value);
    _isVoiceMode = value;
    notifyListeners();
  }

  Future<void> markLaunched({required bool isDisabilityMode}) async {
    _prefs ??= await SharedPreferences.getInstance();
    _isFirstLaunch = false;
    await _prefs!.setBool('isFirstLaunch', false);
    await _prefs!.setString('quranMode', QuranMode.normal.name);
    await _prefs!.setBool('isVoiceMode', isDisabilityMode);

    notifyListeners();
  }

}