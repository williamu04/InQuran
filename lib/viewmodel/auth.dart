import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mtqmnuns/dto/auth.dart';
import 'package:mtqmnuns/exception/auth.dart';
import 'package:mtqmnuns/repositories/auth.dart';
import 'package:mtqmnuns/state/auth.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';

class AuthViewModel extends StatefulViewModel<AuthState> {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _refreshToken;
  String? _jwtToken;
  String? _sessionId;

  final String _refreshStorageKey = 'refresh_token';
  final String _jwtStorageKey = 'jwt';
  final String _sessionIdStorageKey = 'session_id';

  AuthViewModel(this._authRepository) : super(AuthInitial());

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
    setState(AuthAuthenticated(newToken.jwtToken));
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
    setState(AuthLoading());
    _jwtToken = await _storage.read(key: _jwtStorageKey);
    _refreshToken = await _storage.read(key: _refreshStorageKey);
    _sessionId = await _storage.read(key: _sessionIdStorageKey);

    if (_jwtToken == null || _jwtToken!.isEmpty || JwtDecoder.isExpired(_jwtToken!)) {
      refreshToken();
    } else {
      setState(AuthAuthenticated(_jwtToken!));
    }
  }

  Future<void> loginEmail(String email, String password) async {
    setState(AuthLoading());
    try {
      final newToken = await _authRepository.loginEmail(email, password);
      await _writeNewToken(newToken);
    } catch (e) {
      handleApiError(e);
    }
  }

  Future<void> signup(String username, String email, String password) async {
    setState(AuthLoading());
    try {
      final newToken = await _authRepository.registerUser(username, email, password);
      await _writeNewToken(newToken);
    } catch (e) {
      handleApiError(e);
    }
  }

  Future<void> refreshToken() async {
    final refreshToken = _refreshToken;
    final sessionId = _sessionId;
    if (refreshToken == null && sessionId == null) {
      setState(AuthUnauthenticated());
      return;
    } else {
      try {
        final newToken = await _authRepository.refreshToken(refreshToken!, sessionId!);
        await _writeNewToken(newToken);
      } catch (e) {
        handleApiError(e);
      }

    }
  }

  Future<void> logout() async {
    setState(AuthLoggingOut());
    if (_sessionId != null) {
      try {
        await _authRepository.logout(_sessionId!);
        await _clearTokens();
      } catch (e) {
        if (e is NoConnectionError || e is TimeoutError) {
          // TODO: handling offline queue deleting refresh token

        }
        handleApiError(e);
      }
    }
    setState(AuthUnauthenticated());
  }

  void handleApiError(Object error) {
    if (error is RefreshTokenInvalidError) {
      setState(AuthUnauthenticated());
    } else if (error is AppError) {
      setState(AuthError(error.message));
    } else {
      setState(AuthError("UnknownError"));
    }

    if (_jwtToken != null) {
      setState(AuthAuthenticated(_jwtToken!));
    } else {
      setState(AuthUnauthenticated());
    }
  }
}
