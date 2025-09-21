import 'dart:io';
import 'package:mtqmnuns/data/remote/auth.dart';
import 'package:mtqmnuns/dto/auth.dart';
import 'package:mtqmnuns/exception/invalid_token.dart';

class AuthRepository {
  final TokenRemoteDataSource remoteDataSource;

  AuthRepository(this.remoteDataSource);

  Future<TokenDto> refreshToken(String refreshToken, String sessionId) async {
    try {
      final tokenData = await remoteDataSource.fetchTokenRaw(refreshToken, sessionId);
      return TokenDto(
        sessionId: tokenData['sessionId'] as String,
        jwtToken: tokenData['accessToken'] as String,
        refreshToken: tokenData['refreshToken'] as String,
      );
    } on InvalidRefreshTokenException {
      rethrow;
    } on HttpException {
      rethrow; 
    } catch (e) {
      throw HttpException('Gagal memperbarui token: ${e.toString()}');
    }
  }
}
