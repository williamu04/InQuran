import 'package:flutter/material.dart';
import 'package:mtqmnuns/exception/auth.dart';
import 'package:mtqmnuns/repositories/user.dart';
import 'package:mtqmnuns/state/auth.dart';
import 'package:mtqmnuns/state/user.dart';
import 'package:mtqmnuns/viewmodel/auth.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepo;
  final AuthViewModel authVm;

  UserViewModel(this._userRepo, this.authVm);

  UserLoadState _state = UserLoadLoading();
  UserLoadState get state => _state;

  void _setState(UserLoadState state) {
    debugPrint(state.toString());
    _state = state;
    notifyListeners();
  }

  void loadUser() async {
    _state = UserLoadLoading();
    switch (authVm.state) {
      case AuthAuthenticated(:var jwt):
        await _fetchUserFromApi(jwt);
      case AuthUnauthenticated():
      case AuthError():
      case AuthInitial():
      case AuthLoading():
      case AuthLoggingOut():
        if(authVm.isLoggedIn()) {
          await _fetchUserFromCache();
          return;
        } else {
          _setState(UserLoadUnauthenticated());
        }
    }
  }

  Future<void> _fetchUserFromApi(String jwt) async {
    try {
      final user = await _userRepo.getMeFromApi(jwt);
      _setState(UserLoaded(user));
    } on JwtError catch (e) {
      await _retryWithRefreshedToken();
    } catch (e) {
      await handleApiError(e);
    }
  }

  Future<void> _retryWithRefreshedToken() async {
    await authVm.refreshToken();
    if (authVm.state is AuthAuthenticated) {
      final jwt = (authVm.state as AuthAuthenticated).jwt;
      try {
        final user = await _userRepo.getMeFromApi(jwt);
        _setState(UserLoaded(user));
      } catch (e) {
        await handleApiError(e);
      }
    }
  }

  Future<void> handleApiError(Object error) async {
    if (error is AppError) {
      _setState(UserLoadError(error.message));
    } else {
      _setState(UserLoadError("UnknownError"));
    }
  }

  Future<void> _fetchUserFromCache() async {
    throw UnimplementedError();
    // final user = await _userRepo.getMeFromCache();
    // _setState(UserLoaded(user));
  }

}