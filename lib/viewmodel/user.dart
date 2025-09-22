import 'package:flutter/material.dart';
import 'package:mtqmnuns/repositories/user.dart';
import 'package:mtqmnuns/state/auth.dart';
import 'package:mtqmnuns/state/user.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepo;

  UserViewModel(this._userRepo);

  UserLoadState _state = UserLoadLoading();
  UserLoadState get state => _state;

  void _setState(UserLoadState state) {
    debugPrint(state.toString());
    _state = state;
    notifyListeners();
  }

  void loadUser(AuthState authState, bool isLoggedIn) async {
    _state = UserLoadLoading();
    switch (authState) {
      case AuthAuthenticated(:var jwt):
        await _fetchUserFromApi(jwt);
      case AuthUnauthenticated():
      case AuthError():
      case AuthInitial():
      case AuthLoading():
        if(isLoggedIn) {
          _fetchUserFromCache();
          return;
        } else {
          _setState(UserLoadUnauthenticated());
        }
    }
  }

  Future<void> _fetchUserFromApi(String jwt) async {
    final user = await _userRepo.getMeFromApi(jwt);
    _setState(UserLoaded(user));
  }

  Future<void> _fetchUserFromCache() async {
    throw UnimplementedError();
    // final user = await _userRepo.getMeFromCache();
    // _setState(UserLoaded(user));
  }

}