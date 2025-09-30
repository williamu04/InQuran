
import 'dart:io';

import 'package:mtqmnuns/data/local/cache/user.dart';
import 'package:mtqmnuns/data/remote/user.dart';
import 'package:mtqmnuns/dto/auth.dart';
import 'package:mtqmnuns/dto/user.dart';

class UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepository(this.remoteDataSource);

  Future<UserDto> getMeFromApi(String accessToken) async {
    final user = await remoteDataSource.fetchMe(accessToken);
    await UserCache.saveUser(user);
    return user;
  }

  Future<UserDto> getMeFromCache() async {
    final user = await UserCache.loadUser();
    if (user == null) {
      throw Exception("Cache corrupt, please enable internet and try again");
    }
    return user;
  }

  Future<UserDto> updateFullName(String jwt, String newFullName) async {
    try {
      final updatedUser = await remoteDataSource.updateFullName(jwt, newFullName);
      await UserCache.saveUser(updatedUser);
      return updatedUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserDto> updatePhoto(String jwt, File photoFile) async {
    try {
      final updatedUser = await remoteDataSource.uploadPhoto(jwt, photoFile);
      await UserCache.saveUser(updatedUser);
      return updatedUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserDto> updateUser(String jwt, UpdateUserDto updatedUser) async {
    try {
      final newUser = await remoteDataSource.updateUser(jwt, updatedUser);
      await UserCache.saveUser(newUser);
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserDto> bindGoogleOauth(String jwt, GoogleUserDTO info) async {
    try {
      final newUser = await remoteDataSource.bindGoogleOauth(jwt, info);
      await UserCache.saveUser(newUser);
      return newUser;
    } catch (e) {
      rethrow;
    }
  }
  Future<UserDto> bindPassword(String jwt, {required String username, required String password, required String email}) async {
    try {
      final newUser = await remoteDataSource.bindPassword(jwt, username: username, password: password, email: email);
      await UserCache.saveUser(newUser);
      return newUser;
    } catch (e) {
      rethrow;
    }
  }
  Future<UserDto> changePassword(String jwt, {required String oldPassword, required String newPassword}) async {
    try {
      final newUser = await remoteDataSource.changePassword(jwt, oldPassword: oldPassword, newPassword: newPassword);
      await UserCache.saveUser(newUser);
      return newUser;
    } catch (e) {
      rethrow;
    }
  }
}
