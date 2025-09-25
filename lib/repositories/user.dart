
import 'dart:io';

import 'package:mtqmnuns/data/remote/user.dart';
import 'package:mtqmnuns/dto/user.dart';

class UserRepository {
  final  UserRemoteDataSource remoteDataSource;

  UserRepository(this.remoteDataSource);

  Future<UserDto> getMeFromApi(String? accessToken) {
    return remoteDataSource.fetchMe(accessToken);
  }

  Future<void> getMeFromCache() async {

  }

  Future<void> updateFullName(String? jwt, String newFullName) async {
    return await remoteDataSource.updateFullName(jwt, newFullName);

  }

  Future<void> updatePhoto(String? jwt, File photoFile) async {
    return await remoteDataSource.uploadPhoto(jwt, photoFile);
  }

  Future<void> updateUser(String? jwt, UserDto user) async {
    return await remoteDataSource.updateUser(jwt, user);
  }
}