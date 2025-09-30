import 'dart:io';

import 'package:mtqmnuns/dto/auth.dart';
import 'package:mtqmnuns/dto/user.dart';
import 'package:mtqmnuns/repositories/user.dart';
import 'package:mtqmnuns/state/success_or_fail.dart';
import 'package:mtqmnuns/state/user.dart';
import 'package:mtqmnuns/viewmodel/auth.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';

class UserViewModel extends StatefulViewModel<UserLoadState> {
  final UserRepository _userRepo;
  final AuthViewModel authVm;
  
  UserViewModel(this._userRepo, this.authVm) : super(UserLoadLoading());

  Future<void> loadUser() async {
    if (state is UserLoaded) return;
    if (!authVm.isLoggedIn()) {
      setState(UserLoadUnauthenticated());
      return;
    }
    setState(UserLoadLoading());
    try {
      final token = authVm.getValidJwtOrNull();
      if (token == null) {
        final res = await authVm.refreshToken();
        switch(res) {
          case Success<TokenWithUserDto>(:final data):
            setState(UserLoaded(data.user));
            break;
          case Failure():
            setState(UserLoadSessionExpired());
            break;
        }
      } else {
        final user = await _userRepo.getMeFromApi(token);
        setState(UserLoaded(user));
      }
    } catch (e) {
      await _errorFallback();
    }
  }

  Future<SuccessOrFail<UserDto>> updateFullName({required String fullName}) async {
    if (!authVm.isLoggedIn()) {
      setState(UserLoadUnauthenticated());
      return Failure("Unauthenticated");
    }
    try {
      String? token = authVm.getValidJwtOrNull();
      if (token == null) {
        final res = await authVm.refreshToken();
        switch(res) {
          case Success<TokenWithUserDto>(:final data):
            token = data.token.jwtToken;
            break;
          case Failure(:final reason):
            setState(UserLoadSessionExpired());
            return Failure(reason);
        }
      }
      final user = await _userRepo.updateFullName(token, fullName);
      setState(UserLoaded(user));
      return Success<UserDto>(user);
    } catch (e) {
      return Failure(e.toString());
    }

  }
  Future<SuccessOrFail<UserDto>> updatePhoto({required File imageFile}) async {
    if (!authVm.isLoggedIn()) {
      setState(UserLoadUnauthenticated());
      return Failure("Unauthenticated");
    }
    try {
      String? token = authVm.getValidJwtOrNull();
      if (token == null) {
        final res = await authVm.refreshToken();
        switch(res) {
          case Success<TokenWithUserDto>(:final data):
            token = data.token.jwtToken;
            break;
          case Failure(:final reason):
            setState(UserLoadSessionExpired());
            return Failure(reason);
        }
      }
      final user = await _userRepo.updatePhoto(token, imageFile);
      setState(UserLoaded(user));
      return Success<UserDto>(user);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<SuccessOrFail<UserDto>> update({required UpdateUserDto updatedProfileData}) async {
    if (!authVm.isLoggedIn()) {
      setState(UserLoadUnauthenticated());
      return Failure("Unauthenticated");
    }
    try {
      String? token = authVm.getValidJwtOrNull();
      if (token == null) {
        final res = await authVm.refreshToken();
        switch(res) {
          case Success<TokenWithUserDto>(:final data):
            token = data.token.jwtToken;
            break;
          case Failure(:final reason):
            setState(UserLoadSessionExpired());
            return Failure(reason);
        }
      }
      final user = await _userRepo.updateUser(token, updatedProfileData);

      setState(UserLoaded(user));
      return Success<UserDto>(user);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<SuccessOrFail<UserDto>> bindGoogleOauth({required GoogleUserDTO googleInfo}) async {
    if (!authVm.isLoggedIn()) {
      setState(UserLoadUnauthenticated());
      return Failure("Unauthenticated");
    }
    try {
      String? token = authVm.getValidJwtOrNull();
      if (token == null) {
        final res = await authVm.refreshToken();
        switch(res) {
          case Success<TokenWithUserDto>(:final data):
            token = data.token.jwtToken;
            break;
          case Failure(:final reason):
            setState(UserLoadSessionExpired());
            return Failure(reason);
        }
      }
      final user = await _userRepo.bindGoogleOauth(token, googleInfo);
      setState(UserLoaded(user));
      return Success<UserDto>(user);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<SuccessOrFail<UserDto>> bindPassword({required String username, required String password, required String email}) async {
    if (!authVm.isLoggedIn()) {
      setState(UserLoadUnauthenticated());
      return Failure("Unauthenticated");
    }
    try {
      String? token = authVm.getValidJwtOrNull();
      if (token == null) {
        final res = await authVm.refreshToken();
        switch(res) {
          case Success<TokenWithUserDto>(:final data):
            token = data.token.jwtToken;
            break;
          case Failure(:final reason):
            setState(UserLoadSessionExpired());
            return Failure(reason);
        }
      }
      final user = await _userRepo.bindPassword(token, username: username, password: password, email: email);
      setState(UserLoaded(user));
      return Success<UserDto>(user);
    } catch (e) {
      return Failure(e.toString());
    }
  }
  Future<SuccessOrFail<UserDto>> changePassword({required String oldPassword, required String newPassword}) async {
    if (!authVm.isLoggedIn()) {
      setState(UserLoadUnauthenticated());
      return Failure("Unauthenticated");
    }
    try {
      String? token = authVm.getValidJwtOrNull();
      if (token == null) {
        final res = await authVm.refreshToken();
        switch(res) {
          case Success<TokenWithUserDto>(:final data):
            token = data.token.jwtToken;
            break;
          case Failure(:final reason):
            setState(UserLoadSessionExpired());
            return Failure(reason);
        }
      }
      final user = await _userRepo.changePassword(token, oldPassword: oldPassword, newPassword: newPassword);
      setState(UserLoaded(user));
      return Success<UserDto>(user);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<void> _errorFallback() async {
    if (authVm.isLoggedIn()) {
      try {
        final user = await _userRepo.getMeFromCache();
        setState(UserLoadedOffline(user));
      } catch (e){
        setState(UserLoadError(e.toString()));
      }
    } else {
      setState(UserLoadUnauthenticated());
    }
  }

}

  
