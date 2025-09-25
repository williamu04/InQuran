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

  UserViewModel(this._userRepo, this.authVm) : super(UserLoadLoading());

  Future<void> loadUser() async {
    setState(UserLoadLoading());
    if (!authVm.isLoggedIn()) {
      setState(UserLoadUnauthenticated());
      return;
    } 
    await _fetchUserFromApi();
  }

  Future<void> _fetchUserFromApi() async {
    try {
      final jwt = authVm.jwtToken;
      if (jwt == null) {
        await _retryWithRefreshedToken();
        return;
      }
      final user = await _userRepo.getMeFromApi(jwt);
      setState(UserLoaded(user));
    } on JwtError catch (_) {
      await _retryWithRefreshedToken();
      return;
    } catch (e) {
      await _errorFallback();
    }
  }

  Future<void> _retryWithRefreshedToken() async {
      final res = await authVm.refreshToken();
      switch (res) {
        case Success():
          final jwt = authVm.jwtToken;
          if (jwt == null){
            await _errorFallback();
            return;
          }
          try {
            final user = await _userRepo.getMeFromApi(jwt);
            setState(UserLoaded(user));
          } catch (_) {
            await _errorFallback();
          }
        case Failure():
          setState(UserLoadSessionExpired());
          return;
      }
  }

  Future<void> _errorFallback() async {
    if (authVm.isLoggedIn()) {
      await _fetchUserFromCache();
    } else {
      setState(UserLoadUnauthenticated());
    }
  }

  Future<void> _fetchUserFromCache() async {
    setState(UserLoaded(UserDto(id: 1, username: '', email: '', createdAt: DateTime(2024), updatedAt: DateTime(2024))));
    // final user = await _userRepo.getMeFromCache();
    // _setState(UserLoaded(user));
  }

}