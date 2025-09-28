import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mtqmnuns/data/local/cache/user.dart';
import 'package:mtqmnuns/dto/auth.dart';
import 'package:mtqmnuns/exception/http.dart';
import 'package:mtqmnuns/repositories/auth.dart';
import 'package:mtqmnuns/state/success_or_fail.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage;

  final String _refreshStorageKey;
  final String _jwtStorageKey;
  final String _sessionIdStorageKey;

  String? _refreshToken;
  String? _jwtToken;
  String? _sessionId;

  String? get jwtToken => _jwtToken;


  AuthViewModel._(this._authRepository, this._storage, this._refreshStorageKey, this._jwtStorageKey, this._sessionIdStorageKey);

  static Future<AuthViewModel> create(AuthRepository authRepository, FlutterSecureStorage storage) async {
    String refreshKey = 'refreshToken';
    String jwtKey = 'jwtToken';
    String sessionKey = 'sessionId';
    final viewModel = AuthViewModel._(
      authRepository,
      storage,
      refreshKey,
      jwtKey,
      sessionKey,
    );
    viewModel._jwtToken = await storage.read(key: jwtKey);
    viewModel._refreshToken = await storage.read(key: refreshKey);
    viewModel._sessionId = await storage.read(key: sessionKey);

    return viewModel;
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
  }

  Future<void> _clearTokens() async {
    await _deleteJwtToken();
    await _deleteRefreshToken();
    await _deleteSessionId();
  }

  bool isLoggedIn() {
    if (_jwtToken != null && _jwtToken!.isNotEmpty && !JwtDecoder.isExpired(_jwtToken!)) {
      return true; 
    } 
    return _refreshToken != null || _sessionId != null;
  }


  Future<SuccessOrFail> loginEmail(String email, String password) async {
    try {
      final newToken = await _authRepository.loginEmail(email, password);
      await _writeNewToken(newToken);
      return Success<String>('OK');
    } on HttpError catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure("Terjadi Kesalahan Tak Terduga ${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  Future<SuccessOrFail> signup(String username, String email, String password) async {
    try {
      final newToken = await _authRepository.registerUser(username, email, password);
      await _writeNewToken(newToken);
      return Success<String>('OK');
    } on HttpError catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure("Terjadi Kesalahan Tak Terduga ${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  Future<SuccessOrFail<TokenDto>> refreshToken() async {
    await _deleteJwtToken();
    final refreshToken = _refreshToken;
    final sessionId = _sessionId;
    if (refreshToken == null && sessionId == null) {
      return Failure<TokenDto>("Unauthenticated");
    }

    try {
      final newToken = await _authRepository.refreshToken(refreshToken!, sessionId!);
      await _writeNewToken(newToken);
      return Success<TokenDto>(newToken);
    } on RefreshTokenInvalidError catch (_) {
      _clearTokens();
      return Failure<TokenDto>("Session Invalid atau Expired");
    } on HttpError catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure<TokenDto>("Terjadi Kesalahan Tak Terduga ${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    if (_sessionId != null) {
      try {
        await _clearTokens();
        await UserCache.clearUser();
        await _authRepository.logout(_sessionId!);
      } catch (e) {
          // TODO: handling offline queue deleting refresh token
      }
    }
  }
}
