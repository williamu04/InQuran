import 'package:flutter/material.dart';
import 'package:mtqmnuns/dto/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCache {
  static const _userKey = "cachedUser";

  static Future<void> saveUser(UserDto user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, user.toJsonString());
  }

  static Future<UserDto?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString == null) return null;
    return UserDto.fromJsonString(jsonString);
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}