import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mtqmnuns/common/jwt_extension.dart';
import 'package:mtqmnuns/data/local/cache/user.dart';
import 'package:mtqmnuns/dto/user.dart';
import 'package:mtqmnuns/exception/auth.dart';
import 'package:mtqmnuns/repositories/user.dart';
import 'package:mtqmnuns/state/success_or_fail.dart';
import 'package:mtqmnuns/state/user.dart';
import 'package:mtqmnuns/viewmodel/auth.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';
import 'package:path/path.dart' as p;

class UserViewModel extends StatefulViewModel<UserLoadState> {
  final UserRepository _userRepo;
  final AuthViewModel authVm;
  
  UserViewModel(this._userRepo, this.authVm) : super(UserLoadLoading());

  Future<void> loadUser() async {
      setState(UserLoadLoading());
    try {
      final user = await executeWithJwtRetry(
        authVm,
        (token) => _userRepo.getMeFromApi(token),
      );
      await UserCache.saveUser(user);
      setState(UserLoaded(user));
    } on UnauthenticatedException {
      setState(UserLoadUnauthenticated());
    } on TokenRefreshException {
      setState(UserLoadSessionExpired());
    } catch (e) {
      await _errorFallback();
    }
  }

  Future<SuccessOrFail> updateFullName({required String fullName}) async {
    return executeApiOperation(
      authVm,
      (token) => _userRepo.updateFullName(token, fullName),
    );
  }

  Future<SuccessOrFail> updatePhoto({required File imageFile}) async {
    final ext = p.extension(imageFile.path).toLowerCase();
    debugPrint('Extension: $ext');
    return executeApiOperation(
      authVm,
      (token) => _userRepo.updatePhoto(token, imageFile),
      onUnauthenticated: () => setState(UserLoadUnauthenticated()),
    );
  }

  Future<SuccessOrFail> update({required UserDto updatedProfileData}) async {
    return executeApiOperation(
      authVm,
      (token) => _userRepo.updateUser(token, updatedProfileData),
      onUnauthenticated: () => setState(UserLoadUnauthenticated()),
    );
  }

  Future<void> _errorFallback() async {
    if (authVm.isLoggedIn()) {
      await _fetchUserFromCache();
    } else {
      setState(UserLoadUnauthenticated());
    }
  }

  Future<void> _fetchUserFromCache() async {
    final user = await UserCache.loadUser();
    if (user == null) {
      return;
    }
    setState(UserLoadedOffline(user));
  }

}

  
