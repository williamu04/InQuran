import 'package:mtqmnuns/dto/user.dart';
import 'package:mtqmnuns/exception/http.dart';
import 'package:mtqmnuns/repositories/user.dart';
import 'package:mtqmnuns/state/auth.dart';
import 'package:mtqmnuns/state/user.dart';
import 'package:mtqmnuns/viewmodel/auth.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';

class UserViewModel extends StatefulViewModel<UserLoadState> {
  final UserRepository _userRepo;
  final AuthViewModel authVm;

  UserViewModel(this._userRepo, this.authVm) : super(UserLoadLoading());

  void loadUser() async {
    setState(UserLoadLoading());
    if (authVm.state is AuthAuthenticatedOffline) {
      await authVm.init();
    }
    switch (authVm.state) {
      case AuthAuthenticated(:var jwt):
        await _fetchUserFromApi(jwt);
        break;

      case AuthUnauthenticated():
      case AuthError():
      case AuthInitial():
      case AuthLoading():
      case AuthLoggingOut():
        setState(UserLoadUnauthenticated());
        break;

      case AuthAuthenticatedOffline():
        await _fetchUserFromCache();
        break;

      case AuthSessionExpired():
        setState(UserLoadSessionExpired());
        break;
      }
  }

  Future<void> _fetchUserFromApi(String jwt) async {
    try {
      final user = await _userRepo.getMeFromApi(jwt);
      setState(UserLoaded(user));
    } on JwtError catch (_) {
      await _retryWithRefreshedToken();
    } catch (e) {
      await handleApiError(e);
    }
  }

  Future<void> _retryWithRefreshedToken() async {
    try {
      await authVm.refreshToken();
    } on RefreshTokenInvalidError catch (_) {
      setState(UserLoadSessionExpired());
      return;
    }
    if (authVm.state is AuthAuthenticated) {
      final jwt = (authVm.state as AuthAuthenticated).jwt;
      try {
        final user = await _userRepo.getMeFromApi(jwt);
        setState(UserLoaded(user));
      } catch (e) {
        await handleApiError(e);
      }
    }
  }

  Future<void> handleApiError(Object error) async {
    if (error is HttpError) {
      setState(UserLoadError(error.message));
    } else {
      setState(UserLoadError("UnknownError"));
    }
  }

  Future<void> _fetchUserFromCache() async {
    setState(UserLoaded(UserDto(id: 1, username: '', email: '', createdAt: DateTime(2024), updatedAt: DateTime(2024))));
    // final user = await _userRepo.getMeFromCache();
    // _setState(UserLoaded(user));
  }

}