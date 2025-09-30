import 'dart:io';

import 'package:mtqmnuns/dto/auth.dart';
import 'package:mtqmnuns/dto/user.dart';
import 'package:mtqmnuns/exception/http.dart';
import 'package:mtqmnuns/repositories/user.dart';
import 'package:mtqmnuns/state/success_or_fail.dart';
import 'package:mtqmnuns/state/user.dart';
import 'package:mtqmnuns/viewmodel/auth.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';

class UserViewModel extends StatefulViewModel<UserLoadState> {
  final UserRepository _userRepo;
  final AuthViewModel authVm;

  UserViewModel(this._userRepo, this.authVm)
      : super(UserLoadLoading());

  /// ---------------- User Functions ----------------

  Future<void> loadUser() async {
    if (state is UserLoaded) return;

    if (!authVm.isLoggedIn()) {
      setState(UserLoadUnauthenticated());
      return;
    }

    setState(UserLoadLoading());

    try {
      final token = await authVm.getValidTokenOrThrow();
      final user = await _userRepo.getMeFromApi(token);
      setState(UserLoaded(user));
    } on RefreshTokenInvalidError {
      setState(UserLoadSessionExpired());
    } catch (e) {
      await _errorFallback();
    }
  }

  Future<SuccessOrFail<UserDto>> updateFullName({required String fullName}) async {
    try {
      final token = await authVm.getValidTokenOrThrow();
      final user = await _userRepo.updateFullName(token, fullName);
      setState(UserLoaded(user));
      return Success(user);
    } on RefreshTokenInvalidError catch (e) {
      setState(UserLoadSessionExpired());
      return Failure(e.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<SuccessOrFail<UserDto>> updatePhoto({required File imageFile}) async {
    try {
      final token = await authVm.getValidTokenOrThrow();
      final user = await _userRepo.updatePhoto(token, imageFile);
      setState(UserLoaded(user));
      return Success(user);
    } on RefreshTokenInvalidError catch (e) {
      setState(UserLoadSessionExpired());
      return Failure(e.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<SuccessOrFail<UserDto>> update({required UpdateUserDto updatedProfileData}) async {
    try {
      final token = await authVm.getValidTokenOrThrow();
      final user = await _userRepo.updateUser(token, updatedProfileData);
      setState(UserLoaded(user));
      return Success(user);
    } on RefreshTokenInvalidError catch (e) {
      setState(UserLoadSessionExpired());
      return Failure(e.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<SuccessOrFail<UserDto>> bindGoogleOauth({required GoogleUserDTO googleInfo}) async {
    try {
      final token = await authVm.getValidTokenOrThrow();
      final user = await _userRepo.bindGoogleOauth(token, googleInfo);
      setState(UserLoaded(user));
      return Success(user);
    } on RefreshTokenInvalidError catch (e) {
      setState(UserLoadSessionExpired());
      return Failure(e.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<SuccessOrFail<UserDto>> bindPassword({
    required String username,
    required String password,
    required String email,
  }) async {
    try {
      final token = await authVm.getValidTokenOrThrow();
      final user = await _userRepo.bindPassword(
        token,
        username: username,
        password: password,
        email: email,
      );
      setState(UserLoaded(user));
      return Success(user);
    } on RefreshTokenInvalidError catch (e) {
      setState(UserLoadSessionExpired());
      return Failure(e.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<SuccessOrFail<UserDto>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final token = await authVm.getValidTokenOrThrow();
      final user = await _userRepo.changePassword(
        token,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      setState(UserLoaded(user));
      return Success(user);
    } on RefreshTokenInvalidError catch (e) {
      setState(UserLoadSessionExpired());
      return Failure(e.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }



  /// ---------------- Error Fallback ----------------
  Future<void> _errorFallback() async {
    if (authVm.isLoggedIn()) {
      try {
        final user = await _userRepo.getMeFromCache();
        setState(UserLoadedOffline(user));
      } catch (e) {
        setState(UserLoadError(e.toString()));
      }
    } else {
      setState(UserLoadUnauthenticated());
    }
  }
}
