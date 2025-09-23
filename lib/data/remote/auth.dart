import 'dart:io';
import 'package:mtqmnuns/common/exception.dart';
import 'package:mtqmnuns/config/env.dart';
import 'package:mtqmnuns/dto/auth.dart';
import 'package:dio/dio.dart';
import 'package:mtqmnuns/exception/auth.dart';

class AuthRemoteDataSource {
  final Dio client;

  AuthRemoteDataSource({Dio? client}) : client = client ?? Dio();

  Options get _defaultOptions => Options(
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': Env.apiKey,
        },
      );

  Future<TokenDto> refreshToken(String refreshToken, String sessionId) async {
    try {
      final response = await client.post(
        '${Env.baseUrl}/auth/refresh-token',
        data: {'refreshToken': refreshToken, 'sessionId': sessionId},
        options: _defaultOptions,
      );

      return _handleTokenResponse(response);
    } on SocketException catch (e) {
      throw NoConnectionError('Tidak ada koneksi internet: ${e.message}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse &&  e.response?.statusCode == 401) {
        throw RefreshTokenInvalidError(e.response?.data['data']['message']);
      }
      dioExceptionHandler(e);
    }
  }

Future<TokenDto> loginEmail(String email, String password) async {
  try {
    final response = await client.post(
      '${Env.baseUrl}/auth/login',
      data: {'email': email, 'password': password, 'loginType': 'email'},
      options: _defaultOptions,
    );

    return _handleTokenResponse(response);
  } on SocketException catch (e) {
    throw NoConnectionError('Tidak ada koneksi internet: ${e.message}');
  } on DioException catch (e) {
    dioExceptionHandler(e);
  }
}

  Future<TokenDto> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await client.post(
        '${Env.baseUrl}/auth/register',
        data: {'username': username, 'email': email, 'password': password},
        options: _defaultOptions,
      );
      return _handleTokenResponse(response);
    } on SocketException catch (e) {
      throw NoConnectionError('Tidak ada koneksi internet: ${e.message}');
    } on DioException catch (e) {
      dioExceptionHandler(e);
    }
  }

  Future<void> logout(String sessionId) async {
    try {
      await client.post(
        '${Env.baseUrl}/auth/logout',
        data: {'sessionId' : sessionId },
        options: _defaultOptions,
      );
    } on SocketException catch (e) {
      throw NoConnectionError('Tidak ada koneksi internet: ${e.message}');
    } on DioException catch (e) {
      dioExceptionHandler(e);
    }
  }

  TokenDto _handleTokenResponse(Response response) {
    try {
      return TokenDto.fromJson(Map<String, dynamic>.from(response.data['data']));
    } catch (e) {
      throw DataParsingError('Gagal parsing data: ${e.toString()}');
    }
  }
}

