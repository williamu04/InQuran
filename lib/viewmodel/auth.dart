import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mtqmnuns/exception/invalid_token.dart';
import 'package:mtqmnuns/repositories/auth.dart';
import 'package:mtqmnuns/state/auth.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  AuthState _state = AuthInitial();
  AuthState get state => _state;
  String? _jwt;
  String refreshStorageKey = 'refresh_token';
  String sessionIdStorageKey = 'session_id';

  AuthViewModel(this._authRepository);


  void _setState(AuthState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> init() async {
    _setState(AuthLoading());
    if (_jwt == null || _jwt!.isEmpty || JwtDecoder.isExpired(_jwt!)) {
      final refreshToken = await _storage.read(key: refreshStorageKey);
      final sessionId = await _storage.read(key: sessionIdStorageKey);
      if (refreshToken == null || sessionId == null) {
        _setState(AuthUnauthenticated());
        return;
      }

      try {
        final newToken = await _authRepository.refreshToken(refreshToken, sessionId);
        _jwt = newToken.jwtToken;
        await _storage.write(key: refreshStorageKey, value: newToken.refreshToken);
        await _storage.write(key: sessionIdStorageKey, value: newToken.sessionId);
      } on InvalidRefreshTokenException {
        _setState(AuthUnauthenticated());
      } on HttpException {
        // TODO : implement cache for offline mode
        _setState(AuthUnauthenticated());
      } catch (e) {
        _setState(AuthError(e.toString()));
      }
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(_jwt!);
    String? userIds = decodedToken['sub']?.toString();

    if (userIds == null) {
      _setState(AuthError("Internal Server Error (500)"));
      return;
    }

    _setState(AuthAuthenticated(userIds));
  }


  Future<void> login(String username, String password) async {
    _setState(AuthLoading());
    try {
      _setState(AuthAuthenticated('ok'));
    } catch (e) {
      _setState(AuthError("Something went wrong"));
    }
  }

  void logout() {
    _setState(AuthInitial());
  }
}
