import 'package:mtqmnuns/data/remote/auth.dart';
import 'package:mtqmnuns/dto/auth.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository(this.remoteDataSource);

  Future<TokenDto> loginEmail(String email, String password) {
    return remoteDataSource.loginEmail(email, password);
  }

  Future<TokenDto> refreshToken(String refreshToken, String sessionId) {
    return remoteDataSource.refreshToken(refreshToken, sessionId);
  }

  Future<TokenDto> registerUser(String username, String email, String password) {
    return remoteDataSource.register(username, email, password);
  }

  Future<void> logout(String sessionId) {
    return remoteDataSource.logout(sessionId);
  }
}
