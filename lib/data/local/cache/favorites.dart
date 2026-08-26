
import 'dart:convert';

import 'package:inquran/dto/favorites.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteCache {
  static const favKey = "fav";

  static Future<void> saveFavorite(List<FavoriteDto> fav) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(fav.map((f) => f.toJson()).toList());
    await prefs.setString(favKey, jsonString);
  }

  static Future<List<FavoriteDto>?> loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(favKey);
    if (jsonString == null) return null;

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => FavoriteDto.fromJson(json)).toList();
  }

  static Future<void> clearFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(favKey);
  }
}
