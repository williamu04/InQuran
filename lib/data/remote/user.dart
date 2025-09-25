
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mtqmnuns/common/exception.dart';
import 'package:mtqmnuns/config/env.dart';
import 'package:mtqmnuns/dto/user.dart';
import 'package:mtqmnuns/exception/http.dart';

class UserRemoteDataSource {
  final Dio client;

  UserRemoteDataSource({Dio? client}) : client = client ?? Dio();

  Future<UserDto> fetchMe(String? accessToken) async {
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


  Future<void> uploadPhoto(String? accessToken, File photoFile) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          photoFile.path,
          filename: photoFile.path.split('/').last,
        ),
      });

      await client.patch(
        '${Env.baseUrl}/user/profile/me/photo',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
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

  Future<void> updateFullName(String? accessToken, String newFullName) async {
    try {
       await client.patch(
        '${Env.baseUrl}/user/profile/me/fullname',
        data: {'fullName' : newFullName},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
      );
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

  Future<void> updateUser(String? accessToken, UserDto user) async {
        try {
       await client.patch(
        '${Env.baseUrl}/user/profile/me/fullname',
        data: {'username' : user.username, 'email' : user.email, 'fullName' : user.fullName },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
      );
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


} 