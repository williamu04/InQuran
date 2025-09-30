import 'package:mtqmnuns/data/local/cache/user.dart';
import 'package:mtqmnuns/data/remote/auth.dart';
import 'package:mtqmnuns/dto/auth.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository(this.remoteDataSource);

  Future<TokenWithUserDto> loginEmail(String email, String password) async {
    try {
      final result = await remoteDataSource.loginEmail(email, password);
      UserCache.saveUser(result.user);
      return result;
    } catch (e) {
      rethrow; 
    }
  }

  Future<TokenWithUserDto> refreshToken(String refreshToken, String sessionId) async {
    try {
      final result = await remoteDataSource.refreshToken(refreshToken, sessionId);
      UserCache.saveUser(result.user);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<TokenWithUserDto> registerUser(String username, String email, String password) async {
    try {
      final result = await remoteDataSource.register(username, email, password);
      UserCache.saveUser(result.user);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<GoogleTokenWithUserDto> loginGoogleOauth(GoogleUserDTO dto) async {
    try {
      final result = await remoteDataSource.googleOauthLogin(dto);
      UserCache.saveUser(result.user);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout(String sessionId) async {
    try {
      await UserCache.clearUser();
      await remoteDataSource.logout(sessionId);
    } catch (e) {
      rethrow;
    }
  }
}
