
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mtqmnuns/common/exception.dart';
import 'package:mtqmnuns/config/env.dart';
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
      throw DataParsingError('Terjadi kesalahan parsing data user: $e');
    }
  }
} 