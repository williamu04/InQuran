import 'dart:io';
import 'package:mtqmnuns/common/exception.dart';
import 'package:mtqmnuns/config/env.dart';
import 'package:mtqmnuns/dto/auth.dart';
import 'package:dio/dio.dart';
import 'package:mtqmnuns/dto/user.dart';
import 'package:mtqmnuns/exception/http.dart';

class AuthRemoteDataSource {
  final Dio client;

  AuthRemoteDataSource({Dio? client}) : client = client ?? Dio();

  Options get _defaultOptions => Options(
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': Env.apiKey,
        },
      );

  Future<TokenWithUserDto> refreshToken(String refreshToken, String sessionId) async {
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
        throw RefreshTokenInvalidError('Invalid atau sesi expired');
      }
      dioExceptionHandler(e);
    }
  }

Future<TokenWithUserDto> loginEmail(String email, String password) async {
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

  Future<TokenWithUserDto> register(
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

  Future<GoogleTokenWithUserDto> googleOauthLogin(GoogleUserDTO user) async {
    try {
      final response = await client.post(
        '${Env.baseUrl}/auth/register/oauth/google',
        data: {
          "email": user.email,
          "fullName": user.displayName, 
          "googleId": user.id,
        },
        options: _defaultOptions,
      );

      return GoogleTokenWithUserDto(
        TokenDto.fromJson(Map<String, dynamic>.from(response.data['data']['tokens'])),
        UserDto.fromJson(response.data['data']['user']),
        response.data['data']['isNewUser']
      );

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

  TokenWithUserDto _handleTokenResponse(Response response) {
    try {
      return TokenWithUserDto(
        TokenDto.fromJson(Map<String, dynamic>.from(response.data['data']['tokens'])),
        UserDto.fromJson(response.data['data']['user'])
      );
    } catch (e) {
      throw DataParsingError('Gagal parsing data: ${e.toString()}');
    }
  }
}

