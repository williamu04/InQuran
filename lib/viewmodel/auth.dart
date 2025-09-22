import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mtqmnuns/dto/auth.dart';
import 'package:mtqmnuns/exception/auth.dart';
import 'package:mtqmnuns/repositories/auth.dart';
import 'package:mtqmnuns/state/auth.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  AuthState _state = AuthInitial();
  AuthState get state => _state;

  String? _refreshToken;
  String? _jwtToken;
  String? _sessionId;

  final String _refreshStorageKey = 'refresh_token';
  final String _jwtStorageKey = 'jwt';
  final String _sessionIdStorageKey = 'session_id';

  AuthViewModel(this._authRepository);

  void _setState(AuthState state) {
    debugPrint(state.toString());
    _state = state;
    notifyListeners();
  }

  Future<void> _writeRefreshToken(String token) async {
    _refreshToken = token;
    await _storage.write(key: _refreshStorageKey, value: token);
  }

  Future<void> _deleteRefreshToken() async {
    _refreshToken = null;
    await _storage.delete(key: _refreshStorageKey);
  }

  Future<void> _writeJwtToken(String token) async {
    _jwtToken = token;
    await _storage.write(key: _jwtStorageKey, value: token);
  }

  Future<void> _deleteJwtToken() async {
    _jwtToken = null;
    await _storage.delete(key: _jwtStorageKey);
  }

  Future<void> _writeSessionId(String sessionId) async {
    _sessionId = sessionId;
    await _storage.write(key: _sessionIdStorageKey, value: sessionId);
  }

  Future<void> _deleteSessionId() async {
    _sessionId = null;
    await _storage.delete(key: _sessionIdStorageKey);
  }

  Future<void> _writeNewToken(TokenDto newToken) async {
    await _writeRefreshToken(newToken.refreshToken);
    await _writeJwtToken(newToken.jwtToken);
    await _writeSessionId(newToken.sessionId);
    _setState(AuthAuthenticated(newToken.jwtToken));
  }

  Future<void> _clearTokens() async {
    await _deleteJwtToken();
    await _deleteRefreshToken();
    await _deleteSessionId();
  }

  bool isLoggedIn() {
    return _refreshToken != null && _sessionId != null;
  }

  Future<void> init() async {
    _setState(AuthLoading());
    _jwtToken = await _storage.read(key: _jwtStorageKey);
    _refreshToken = await _storage.read(key: _refreshStorageKey);
    _sessionId = await _storage.read(key: _sessionIdStorageKey);

    if (_jwtToken == null || _jwtToken!.isEmpty || JwtDecoder.isExpired(_jwtToken!)) {
      if (_refreshToken == null || _sessionId == null) {
        _setState(AuthUnauthenticated());
        return;
      }
      try {
        final newToken = await _authRepository.refreshToken(_refreshToken!, _sessionId!);
        await _writeNewToken(newToken);
      } catch (e) {
        handleApiError(e);
      }
    } else {
      _setState(AuthAuthenticated(_jwtToken!));
    }
  }

  Future<void> loginEmail(String email, String password) async {
    _setState(AuthLoading());
    try {
      final newToken = await _authRepository.loginEmail(email, password);
      await _writeNewToken(newToken);
    } catch (e) {
      handleApiError(e);
    }
  }

  Future<void> signup(String username, String email, String password) async {
    _setState(AuthLoading());
    try {
      final newToken = await _authRepository.registerUser(username, email, password);
      await _writeNewToken(newToken);
    } catch (e) {
      handleApiError(e);
    }
  }

  Future<void> logout() async {
    _setState(AuthLoading());
    try {
      if (_sessionId != null) {
        await _authRepository.logout(_sessionId!);
      }
      await _clearTokens();
      _setState(AuthUnauthenticated());
    } catch (e) {
      handleApiError(e);
    }
  }

  void handleApiError(Object error) {
    if (error is AppError) {
      _setState(AuthError(error.message));
    } else {
      _setState(AuthError("UnknownError"));
    }
  }
}
