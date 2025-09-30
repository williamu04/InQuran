
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mtqmnuns/common/exception.dart';
import 'package:mtqmnuns/config/env.dart';
import 'package:mtqmnuns/dto/auth.dart';
import 'package:mtqmnuns/dto/user.dart';
import 'package:mtqmnuns/exception/http.dart';

class UserRemoteDataSource {
  final Dio client;

  UserRemoteDataSource({Dio? client}) : client = client ?? Dio();

  Future<UserDto> fetchMe(String accessToken) async {
    try {
      final response = await client.get(
        '${Env.baseUrl}/user/profile/me',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
      );

      return UserDto.fromJson(response.data['data']);
    } on SocketException catch (e) {
      throw NoConnectionError('Tidak ada koneksi internet: ${e.message}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse &&  e.response?.statusCode == 401) {
          throw JwtError("Sesi Habis");
      }
      dioExceptionHandler(e);
    } on FormatException catch (e) {
      throw DataParsingError('Gagal parsing data user: ${e.message}');
    } catch (e) {
      debugPrint("[ERROR] ${e.toString()}");
      throw HttpError('terdapat Kesalahan tak terduga');
    }
  }


  Future<UserDto> uploadPhoto(String accessToken, File photoFile) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          photoFile.path,
          filename: photoFile.path.split('/').last,
        ),
      });

      final response = await client.patch(
        '${Env.baseUrl}/user/profile/me/photo',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return UserDto.fromJson(response.data['data']);
    } on SocketException catch (e) {
      throw NoConnectionError('Tidak ada koneksi internet: ${e.message}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse &&
          e.response?.statusCode == 401) {
        throw JwtError("Sesi Habis");
      }
      dioExceptionHandler(e);
    } on FormatException catch (e) {
      throw DataParsingError('Gagal parsing data user: ${e.message}');
    } catch (e) {
      throw HttpError('terdapat Kesalahan tak terduga');
    }
  }

  Future<UserDto> updateFullName(String accessToken, String newFullName) async {
    try {
       final response = await client.patch(
        '${Env.baseUrl}/user/profile/me/fullname',
        data: {'fullName' : newFullName},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
      );
      return UserDto.fromJson(response.data['data']);
    } on SocketException catch (e) {
      throw NoConnectionError('Tidak ada koneksi internet: ${e.message}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse &&  e.response?.statusCode == 401) {
          throw JwtError("Sesi Habis");
      }
      dioExceptionHandler(e);
    } on FormatException catch (e) {
      throw DataParsingError('Gagal parsing data user: ${e.message}');
    } catch (e) {
      throw HttpError('terdapat Kesalahan tak terduga');
    }
  }

  Future<UserDto> updateUser(String accessToken, UpdateUserDto user) async {
      try {
       final response = await client.put(
        '${Env.baseUrl}/user/profile/me',
        data: {'username' : user.username, 'email' : user.email, 'fullName' : user.fullName },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
      );
      return UserDto.fromJson(response.data['data']);
    } on SocketException catch (e) {
      throw NoConnectionError('Tidak ada koneksi internet: ${e.message}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse &&  e.response?.statusCode == 401) {
          throw JwtError("Sesi Habis");
      }
      dioExceptionHandler(e);
    } on FormatException catch (e) {
      throw DataParsingError('Gagal parsing data user: ${e.message}');
    } catch (e) {
      debugPrint("[ERROR] ${e.toString}");
      throw HttpError('terdapat Kesalahan tak terduga');
    }
  }

  Future<UserDto> bindGoogleOauth(String accessToken, GoogleUserDTO user) async {
    try {
      final response = await client.put(
        '${Env.baseUrl}/user/bind/oauth/google',
        data: {
          "email": user.email,
          "fullName": user.displayName, 
          "googleId": user.id,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
      );

      return UserDto.fromJson(response.data['data']);

    } on SocketException catch (e) {
      throw NoConnectionError('Tidak ada koneksi internet: ${e.message}');
    } on DioException catch (e) {
      dioExceptionHandler(e);
    }
  }
  Future<UserDto> bindPassword(String accessToken, {required String username, required String password, required String email}) async {
    try {
      final response = await client.put(
        '${Env.baseUrl}/user/bind/password',
        data: {
          "email": email,
          "password": password, 
          "username": username,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
      );

      return UserDto.fromJson(response.data['data']);

    } on SocketException catch (e) {
      throw NoConnectionError('Tidak ada koneksi internet: ${e.message}');
    } on DioException catch (e) {
      dioExceptionHandler(e);
    }
  }

  Future<UserDto> changePassword(String accessToken, {required String oldPassword, required String newPassword}) async {
    try {
      final response = await client.put(
        '${Env.baseUrl}/user/password/change',
        data: {
          'newPassword' : newPassword,
          'oldPassword' : oldPassword
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
      );

      return UserDto.fromJson(response.data['data']);

    } on SocketException catch (e) {
      throw NoConnectionError('Tidak ada koneksi internet: ${e.message}');
    } on DioException catch (e) {
      dioExceptionHandler(e);
    }
  }
} 
