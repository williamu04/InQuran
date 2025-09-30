
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mtqmnuns/common/exception.dart';
import 'package:mtqmnuns/config/env.dart';
import 'package:mtqmnuns/dto/favorites.dart';

class FavoritesDataSource {
  final Dio client;

  FavoritesDataSource({Dio? client}) : client = client ?? Dio();

  Future<List<FavoriteDto>> getAllFavorites(String accessToken) async {
    try {
      final response = await client.get(
        '${Env.baseUrl}/user/favorites', 
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final data = response.data['data'] as List<dynamic>;
      return data.map((item) => FavoriteDto.fromJson(item)).toList();
    } on SocketException catch (e) {
      throw Exception('Tidak ada koneksi internet: ${e.message}');
    } on DioException catch (e) {
        dioExceptionHandler(e);
    }
  }

  Future<List<FavoriteDto>> addFavorite(String accessToken, FavoriteDto favorite) async {
    try {
      final response = await client.post(
        '${Env.baseUrl}/user/favorite/add',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: {
          "surah_number" : favorite.surahNumber,
          "ayah_number" : favorite.ayahNumber,
        },
      );
      final data = response.data['data'] as List<dynamic>;
      return data.map((item) => FavoriteDto.fromJson(item)).toList();
    } on SocketException catch (e) {
      throw Exception('No internet connection: ${e.message}');
    } on DioException catch (e) {
        dioExceptionHandler(e);
    }
  }

  Future<List<FavoriteDto>> deleteFavorite(String accessToken, FavoriteDto favorite) async {
    try {
      final response = await client.post(
        '${Env.baseUrl}/user/favorite/delete',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: {
          "surah_number" : favorite.surahNumber,
          "ayah_number" : favorite.ayahNumber,
        },
      );
      final data = response.data['data'] as List<dynamic>;
      return data.map((item) => FavoriteDto.fromJson(item)).toList();
    } on SocketException catch (e) {
      throw Exception('No internet connection: ${e.message}');
    } on DioException catch (e) {
        dioExceptionHandler(e);
    }
  }

} 
